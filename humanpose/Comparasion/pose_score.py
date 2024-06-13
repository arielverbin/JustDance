from abc import ABC, abstractmethod
import numpy as np


class PoseScore(ABC):
    @abstractmethod
    def process_target(self, target_pose):
        pass

    @abstractmethod
    def convert_to_score(self, value):
        pass

    @abstractmethod
    def compare(self, preprocessed_target, pose):
        pass
