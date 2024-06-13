import numpy as np


def calc_angle(vec1, vec2):
    """
        Calculate the angle between two vectors in the format (x1,y1), (x2,y2).
        Returns:
            (float): the angle in degrees.
    """

    v1 = vec1[0] - vec1[1]
    v2 = - vec2[0] + vec2[1]

    # Compute the dot product
    dot_product = np.dot(v1, v2)

    # Compute the magnitudes of the vectors
    magnitude_v1 = np.linalg.norm(v1)
    magnitude_v2 = np.linalg.norm(v2)

    # Compute the cosine of the angle
    cos_angle = dot_product / (magnitude_v1 * magnitude_v2)
    cos_angle = np.clip(cos_angle, -1.0, 1.0)

    angle_radians = np.arccos(cos_angle)

    # Compute the angle in radians - and scale to [0,2]
    return np.degrees(angle_radians)


def calculate_gaussian_weights(num_weights, time_interval, bias, sigma):
    f"""
    Samples {num_weights} values from the gaussian distribution.

    Parameters:
    -----------
    num_weights : int
        The number of weights to generate.
    time_interval : float
        The time interval between each weight.
    bias : float
        The bias from the middle of the time.
    sigma : float
        The sigma parameter determining how quickly the weight decreases from its peak.

    Returns:
    --------
    array_like
        An array of weights generated based on a Gaussian distribution.
    """
    # Calculate weights using Gaussian distribution
    indices = np.arange(num_weights)
    bias = (num_weights // 2) * time_interval - bias
    weights = np.exp(-0.5 * ((indices * time_interval - bias) / sigma) ** 2)

    return weights
