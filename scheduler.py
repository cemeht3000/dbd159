""" Scheduler Function """
import logging
import os
import yandexcloud

from yandex.cloud.compute.v1.instance_service_pb2 import (
    ListInstancesRequest,
    StartInstanceRequest,
    StopInstanceRequest
)
from yandex.cloud.compute.v1.instance_service_pb2_grpc import InstanceServiceStub

from yandex.cloud.compute.v1.instancegroup.instance_group_service_pb2 import (
    StopInstanceGroupRequest,
    StartInstanceGroupRequest,
    ListInstanceGroupsRequest
)
from yandex.cloud.compute.v1.instancegroup.instance_group_service_pb2_grpc import InstanceGroupServiceStub

from yandex.cloud.apploadbalancer.v1.load_balancer_service_pb2 import (
    StartLoadBalancerRequest,
    StopLoadBalancerRequest,
    ListLoadBalancersRequest
)
from yandex.cloud.apploadbalancer.v1.load_balancer_service_pb2_grpc import LoadBalancerServiceStub

from yandex.cloud.mdb.postgresql.v1.cluster_service_pb2 import (
    StartClusterRequest,
    StopClusterRequest,
    ListClustersRequest
)
from yandex.cloud.mdb.postgresql.v1.cluster_service_pb2_grpc import ClusterServiceStub


token = os.getenv("YS_OAUTH_TOKEN")
folder_id = os.getenv("YS_FOLDER_ID", "b1g2bq1d2ib9ans76icf")
operation = os.getenv("YS_OPERATION", "start")
tag_filter_key = os.getenv("YS_TAG_FILTER_KEY", "environment")
tag_filter_value = os.getenv("YS_TAG_FILTER_VALUE", "nonexistent")
logging_level = os.getenv("YS_LOGGING_LEVEL", "INFO")
cloud_service = os.getenv("YS_CLOUD_SERVICE")

cloud_service_list = list(cloud_service.split(", "))


logger = logging.getLogger()
logger.setLevel(getattr(logging, logging_level))
if len(logger.handlers) > 0:
    root_handler = logger.handlers[0]
    root_handler.setFormatter(logging.Formatter(
        '%(levelname)s %(message)s'
    ))


def handler(event, context):
    """ Main Cloud Function handler """
    sdk = yandexcloud.SDK(token=token)
    instance_service = sdk.client(InstanceServiceStub)
    instance_group_service = sdk.client(InstanceGroupServiceStub)
    load_balancer_service = sdk.client(LoadBalancerServiceStub)
    cluster_service = sdk.client(ClusterServiceStub)


    def instance_and_instance_groups():

        # Process instance groups
        instance_groups = instance_group_service.List(ListInstanceGroupsRequest(folder_id=folder_id)).instance_groups
        processed_instance_groups = []

        for instance_group in instance_groups:
            logger.debug(f'Instance_group {instance_group.name} STATUS - {instance_group.status}')

            if instance_group.labels.get(tag_filter_key) == tag_filter_value and operation == "start":
                processed_instance_groups.append(instance_group.name)
                if instance_group.status == 2:
                    logger.info(f'Instance_group "{instance_group.name}" is ACTIVE - Skipping')
                elif instance_group.status == 4:
                    logger.info(f'Instance_group "{instance_group.name}" is STOPPED - Starting')
                    instance_group_service.Start(StartInstanceGroupRequest(instance_group_id=instance_group.id))
                     
            elif instance_group.labels.get(tag_filter_key) == tag_filter_value and operation == "stop":
                processed_instance_groups.append(instance_group.name)
                if instance_group.status == 4:
                    logger.info(f'Instance_group "{instance_group.name}" is STOPPED - Skipping')
                elif instance_group.status == 2:
                    logger.info(f'Instance_group "{instance_group.name}" is ACTIVE - Stopping')
                    instance_group_service.Stop(StopInstanceGroupRequest(instance_group_id=instance_group.id))
            else:
                logger.debug(f'Skipping instance_group: name-{instance_group.name} id-{instance_group.id}')

        # Process instances
        instances = instance_service.List(ListInstancesRequest(folder_id=folder_id)).instances

        for instance in instances:
            logger.debug(f'Instance {instance.name} STATUS - {instance.status}')

            if (instance.labels.get(tag_filter_key) == tag_filter_value and instance.labels.get('instance_group') not in processed_instance_groups and operation == "start"):
                if instance.status == 2:
                    logger.info(f'Instance "{instance.name}" is ACTIVE - Skipping')
                elif instance.status == 4:
                    logger.info(f'Instance "{instance.name}" is STOPPED - Starting')
                    instance_service.Start(StartInstanceRequest(instance_id=instance.id))
                
            elif (instance.labels.get(tag_filter_key) == tag_filter_value and instance.labels.get('instance_group') not in processed_instance_groups and operation == "stop"):
                if instance.status == 4:
                    logger.info(f'Instance "{instance.name}" is STOPPED - Skipping')
                elif instance.status == 2:
                    logger.info(f'Instance "{instance.name}" is ACTIVE - Stopping')
                    instance_service.Stop(StopInstanceRequest(instance_id=instance.id))
            else:
                logger.debug(f'Skipping instance: name-{instance.name} id-{instance.id}')
                
                
    def application_load_balancers():

        # List loadbalancers
        load_balancers = load_balancer_service.List(ListLoadBalancersRequest(folder_id=folder_id)).load_balancers

        for load_balancer in load_balancers:
            logger.debug(f'Load_balancer {load_balancer.name} STATUS - {load_balancer.status}')

            if load_balancer.labels.get(tag_filter_key) == tag_filter_value and operation == "start":
                if load_balancer.status == 3:
                    logger.info(f'Load_balancer "{load_balancer.name}" is ACTIVE - Skipping')
                elif load_balancer.status == 5:
                    logger.info(f'Load_balancer "{load_balancer.name}" is STOPPED - Starting')
                    load_balancer_service.Start(StartLoadBalancerRequest(load_balancer_id=load_balancer.id))
                
            elif load_balancer.labels.get(tag_filter_key) == tag_filter_value and operation == "stop":
                if load_balancer.status == 5:
                    logger.info(f'Load_balancer "{load_balancer.name}" is STOPPED - Skipping')
                elif load_balancer.status == 3:
                    logger.info(f'Load_balancer "{load_balancer.name}" is ACTIVE - Stopping')
                    load_balancer_service.Stop(StopLoadBalancerRequest(load_balancer_id=load_balancer.id))
            else:
                logger.debug(f'Skipping load_balancer: name-{load_balancer.name} id-{load_balancer.id}')
    

    def postgresql_cluster_service():

        #List cluster_services
        clusters = cluster_service.List(ListClustersRequest(folder_id=folder_id)).clusters

        for cluster in clusters:
            logger.debug(f'Cluster {cluster.name} STATUS - {cluster.status}')

            if cluster.labels.get(tag_filter_key) == tag_filter_value and operation == "start":
                if cluster.status == 2:
                    logger.info(f'Сluster "{cluster.name}" is RUNNING - Skipping')
                elif cluster.status == 6:
                    logger.info(f'Сluster "{cluster.name}" is STOPPED - Starting')
                    cluster_service.Start(StartClusterRequest(cluster_id=cluster.id))
                
            elif cluster.labels.get(tag_filter_key) == tag_filter_value and operation == "stop":
                if cluster.status == 6:
                    logger.info(f'Сluster "{cluster.name}" is STOPPED - Skipping')
                elif cluster.status == 2:
                    logger.info(f'Сluster "{cluster.name}" is RUNNING - Stopping')
                    cluster_service.Stop(StopClusterRequest(cluster_id=cluster.id))
            else:
                logger.debug(f'Skipping cluster: name-{cluster.name} id-{cluster.id}')


    logger.info(f'Services - {cloud_service}. Operation - {operation}')

    if "alb" in cloud_service_list:
        application_load_balancers()
    
    if "compute" in cloud_service_list:
        instance_and_instance_groups()
    
    if "psql" in cloud_service_list:
        postgresql_cluster_service()


# For local execution
if __name__ == "__main__":
    handler("nach", "os")
