import torch.nn as nn

from Inference.model.backbone import ViT
from Inference.model.head import TopdownHeatmapSimpleHead

__all__ = ['ViTPose']


class ViTPose(nn.Module):
    def __init__(self, cfg: dict) -> None:
        super(ViTPose, self).__init__()

        backbone_cfg = {k: v for k, v in cfg['backbone'].items() if k != 'type'}
        head_cfg = {k: v for k, v in cfg['keypoint_head'].items() if k != 'type'}

        self.backbone = ViT(**backbone_cfg)
        print(head_cfg)
        self.keypoint_head = TopdownHeatmapSimpleHead(**head_cfg)

    def forward_features(self, x):
        return self.backbone(x)

    def forward(self, x):
        return self.keypoint_head(self.backbone(x))
