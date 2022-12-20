########
nuScenes
########

`<https://www.nuscenes.org/nuscenes>`_

********
Overview
********

The nuScenes dataset (pronounced /nuːsiːnz/) is a public large-scale dataset
for autonomous driving developed by the team at `Motional
<https://www.motional.com/>`__ (formerly nuTonomy). Motional is making
driverless vehicles a safe, reliable, and accessible reality.  By releasing a
subset of our data to the public, Motional aims to support public research into
computer vision and autonomous driving.

For this purpose we collected 1000 driving scenes in Boston and Singapore, two
cities that are known for their dense traffic and highly challenging driving
situations. The scenes of 20 second length are manually selected to show a
diverse and interesting set of driving maneuvers, traffic situations and
unexpected behaviors. The rich complexity of nuScenes will encourage
development of methods that enable safe driving in urban areas with dozens of
objects per scene. Gathering data on different continents further allows us to
study the generalization of computer vision algorithms across different
locations, weather conditions, vehicle types, vegetation, road markings and
left versus right hand traffic.

To facilitate common computer vision tasks, such as object detection and
tracking, we annotate 23 object classes with accurate 3D bounding boxes at 2Hz
over the **entire** dataset. Additionally we annotate object-level attributes
such as visibility, activity and pose.

**In March 2019, we released the full nuScenes dataset with all 1,000 scenes.**
The full dataset includes approximately 1.4M camera images, 390k LIDAR sweeps,
1.4M RADAR sweeps and 1.4M object bounding boxes in 40k keyframes. Additional
features (map layers, raw sensor data, etc.) will follow soon. We are also
organizing the **nuScenes 3D detection challenge as part of the Workshop on
Autonomous Driving at CVPR 2019.**

The nuScenes dataset is inspired by the pioneering `KITTI
<http://www.cvlibs.net/datasets/kitti/>`__ dataset.  nuScenes is the first
large-scale dataset to provide data from the entire sensor suite of an
autonomous vehicle (6 cameras, 1 LIDAR, 5 RADAR, GPS, IMU). Compared to KITTI,
nuScenes includes 7x more object annotations.

Whereas most of the previously released datasets focus on camera-based object
detection (`Cityscapes <https://www.cityscapes-dataset.com/>`__, `Mapillary
Vistas <https://www.mapillary.com/dataset/vistas>`__, `Apolloscapes
<http://apolloscape.auto/>`__, `Berkeley Deep Drive
<http://bdd-data.berkeley.edu/>`__), the goal of nuScenes is to look at the
entire sensor suite.

**In July 2020, we released nuScenes-lidarseg.** In nuScenes-lidarseg, we
annotate each lidar point from a keyframe in nuScenes with one of 32 possible
semantic labels (i.e. lidar semantic segmentation). As a result,
nuScenes-lidarseg contains 1.4 billion annotated points across 40,000
pointclouds and 1000 scenes (850 scenes for training and validation, and 150
scenes for testing).

The nuScenes dataset is available as free to use strictly for non-commercial
purposes. Non-commercial means not primarily intended for or directed towards
commercial advantage or monetary compensation.  Examples of non-commercial use
include but are not limited to personal use, educational use, such as in
schools, academies, universities etc., and some research use. If you intend to
use the nuScenes dataset for commercial purposes, we encourage you to contact
us for commercial licensing options by sending an e-mail to
nuScenes@motional.com.

We hope that this dataset will allow researchers across the world to develop
safe autonomous driving technology.

Please use the following citation when referencing nuScenes:

::

   @article{nuscenes2019,
    title={nuScenes: A multimodal dataset for autonomous driving},
     author={Holger Caesar and Varun Bankiti and Alex H. Lang and Sourabh Vora and 
             Venice Erin Liong and Qiang Xu and Anush Krishnan and Yu Pan and 
             Giancarlo Baldan and Oscar Beijbom}, 
     journal={arXiv preprint arXiv:1903.11027},
     year={2019}
   }
