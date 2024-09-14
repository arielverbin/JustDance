from abc import ABC, abstractmethod


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

    @abstractmethod
    def compare_preprocessed(self, preprocessed_target, preprocessed_pose):
        pass
