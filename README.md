# SuperSafety System

## Table of Contents
- [Project Description](#project-description)
- [GAN (Generative Adversarial Networks)](#gan-generative-adversarial-networks)
  - [Progressive Growing GAN (PGGAN)](#progressive-growing-gan-pggan)
  - [Enhanced Super-Resolution GAN (ESRGAN)](#enhanced-super-resolution-gan-esrgan)
- [Computer Vision with SSD](#computer-vision-with-ssd)
- [Mobile Application](#mobile-application)
- [Embedded System](#embedded-system)

## Project Description

Our project focuses on enhancing safety and monitoring in industrial settings by leveraging state-of-the-art technologies. We use Generative Adversarial Networks (GANs) to address the challenge of low-quality camera feeds in factories. The GANs are employed for superresolution, improving image quality and clarity, thereby enhancing the accuracy of hazard detection systems. These enhanced images are then processed using Single Shot Multibox Detector (SSD) in computer vision, allowing for the identification and analysis of potential hazards within the industrial environment. The entire system is embedded into a chip and seamlessly integrated with a mobile application, providing real-time hazard alerts and safety assessments.

---

## GAN (Generative Adversarial Networks)

### Progressive Growing GAN (PGGAN)

Our project has achieved significant advancements in GAN models, with a primary focus on Progressive Growing GAN (PGGAN). PGGAN is renowned for its ability to generate high-resolution images progressively. By training on low-resolution images and incrementally increasing the complexity, PGGAN ensures that the generated images maintain superior quality, making it an ideal choice for enhancing the resolution of factory surveillance footage.

### Enhanced Super-Resolution GAN (ESRGAN)

Another key GAN model in our arsenal is Enhanced Super-Resolution GAN (ESRGAN). ESRGAN excels in superresolution tasks, producing images with remarkable details and sharpness. Leveraging advanced deep learning techniques, ESRGAN further enhances the clarity of our surveillance footage, contributing to the overall effectiveness of our hazard detection system.

---

## Computer Vision with SSD

Our computer vision module employs the Single Shot Multibox Detector (SSD) for object detection in the enhanced images generated by our GANs. SSD is a robust and efficient object detection algorithm that excels in real-time applications. Its ability to accurately identify and classify objects in images makes it an integral component of our hazard detection system.

### MobileNet SSD

We have included the code for MobileNet SSD, a lightweight and efficient deep neural network architecture. MobileNet SSD is specifically designed for resource-constrained environments, making it suitable for real-time applications. Its speed and accuracy make it an excellent choice for our hazard detection system, ensuring rapid and precise object detection in the enhanced images produced by our GANs.

### YOLOv8

In addition to MobileNet SSD, we have incorporated the code for YOLOv8 (You Only Look Once version 8). YOLOv8 represents a state-of-the-art object detection framework known for its speed and accuracy. The YOLO architecture processes images in a single forward pass, enabling fast and reliable object detection. By integrating YOLOv8 into our computer vision module, we further expand the range of capabilities, providing an alternative solution for comprehensive object detection.

---

## Mobile Application

The project includes a mobile application designed for real-time monitoring and alerting. The application provides users with immediate hazard notifications, leveraging the embedded system's analysis of enhanced surveillance footage. Users can receive alerts, view live camera feeds, and access historical data for a comprehensive overview of safety in the industrial environment.

---

## Embedded System

Our system is seamlessly embedded into a dedicated chip, ensuring efficient and real-time processing of surveillance footage. The embedded system incorporates the GAN models for superresolution and the SSD algorithm for hazard detection. This integration allows for quick and reliable analysis, contributing to the overall safety enhancement in industrial settings.

---

This README provides an overview of our project, detailing the utilization of state-of-the-art GAN models (PGGAN and ESRGAN) for superresolution and the integration of SSD in computer vision for hazard detection. The chosen models and algorithms have been carefully selected to ensure the reliability and effectiveness of our embedded system, which is designed to enhance safety and monitoring in industrial settings. For more detailed information, please refer to the relevant sections on GANs, computer vision, the mobile application, and the embedded system in this document.
