from concurrent import futures
import time
from grpc_service import service_pb2_grpc
from grpc_service import service_pb2


class PoseScoringService(service_pb2_grpc.ScoringPoseService):

    def __init__(self):
        self.state = 0

    def loadService(self, request, context):
        time.sleep(10)
        return service_pb2.loadStatus(status="success")

    def getScore(self, request, context):
        self.state = self.state + 1
        return service_pb2.ScoreResponse(score=self.state)
