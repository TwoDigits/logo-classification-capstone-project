# Logo Capstone Project

## Installation Instructions

1. Clone the git repository of the Logo Capstone Project from [Github](https://github.com/ajuschka/capstone_project.git).

2. [Install Anaconda](https://docs.anaconda.com/anaconda/install/)

3. Clone Tensorflow's Object Detection API from  [Github](https://github.com/ajuschka/capstone_project.git).

4. Either execute 
``` bash
# From Logo Capstone Project directory
$ conda create --name mypy3 
```
and follow the [installation instructions](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md), or install the required packages with
``` bash
# From Logo Capstone Project directory
$ conda create --name mypy3 --file requirements-mypy3.txt
```

### Getting the Logos in the Wild dataset

5. Ask for permission and then download the [Logos in the Wild dataset](https://www.iosb.fraunhofer.de/servlet/is/78045/) to the Logo Capstone Project directory.

6. Download the superset [QMUL-OpenLogo Dataset (4.7 GB)](https://qmul-openlogo.github.io/) that contains all available JPEGs to the Logos In the Wild dataset.

7. After changing in Logo Capstone Project/move_JPEG_files.sh the variable "oldpath" to the absolute path of your LogosInTheWild-v2/data-directory and "newpath" to the absolute path of your openlogo/JPEGImages-directory, enter the following:
``` bash
# From Logo Capstone Project directory
$ ./move_JPEG_files.sh
```

8. In order to remove XML files without corresponding JPEG images from the Logos in the Wild dataset and du adjust brand names, remove the 0samples folder from the LogosInTheWild-v2/data directory, and execute in a separate Conda environment with Python 2.7 and opencv-python
``` bash
# From LogosInTheWild-v2/scripts directory
$ python create_clean_dataset.py --roi --in ../data --out ../cleaned-data
```
This outputs that 9,428 images and 821 brands were processed, while 1,330 JPEG files were unavailable.

### Custom Logo Classification CNNs in Keras

9. Open Logo Capstone Project/logo_classification.ipynb in a jupyter notebook, adjust the paths and execute the cells.

### Creating TFRecord files for Tensorflow's Object Dectection API

10. For [this necessary conversion of our dataset to Tensorflow's TFRecord file format](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/preparing_inputs.md), copy our adaption of Tensorflow's [create_pascal_tf_record.py](https://github.com/tensorflow/models/blob/master/research/object_detection/dataset_tools/create_pascal_tf_record.py) script create_and_analyze_pascal_tf_record.py from the Logo Capstone Project to the LogosInTheWild-v2 directoy.

11.  In order to convert the Logos in the Wild dataset to TFRecord files, we run
``` bash
# From LogosInTheWild-v2 directory
$ python create_and_analyze_pascal_tf_record.py --data_dir=./data/voc_format --label_map_path=./data/pascal_label_map.pbtxt --output_path=./data/
```
This converts 6,034 images with annotations into the 10 training TFRecord files \path{pascal_train.record-0000i-of-00010}, and 1,508 images with annotations into the 10 validation TFRecord files \path{pascal_val.record-0000i-of-00010} for i=0,...,9.
Further, in LogosInTheWild-v2/data this created \path{test_images.txt} containing the absolute path of the 1,886 images in the test set, and pascal_label_map.pbtxt containing 821 entries like the following:
``` python
item {
  id: 262
  name: 'starbucks-text'
}
```

### Training a custom Faster R-CNN with Tensorflow's Object Dectection API

12. Make sure to move the respective files (from the Capstone Project Repository) so that the directory structure is as recommended in Tensorflow's [running_locally.md](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_locally.md):
+ "data" directory
  - pascal_label_map.pbtxt
  - 10 files pascal_train.record-0000i-of-00010 for i = 0,...,9
  - 10 files pascal_val.record-0000i-of-00010 i = 0,...,9
+ "models" directory
  + "model" directory
    - faster_rcnn_inception_logos-locally-on-ubuntu.config
    + "train" directory
    + "eval" directory,

13. Train the Faster R-CNN on our dataset by running the following Python script:
``` bash
# From tensorflow/models/research directory
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python object_detection/model_main.py \
    --model_dir=PATH_TO/LogosInTheWild-v2/models/model/ \
    --pipeline_config_path=PATH_TO/LogosInTheWild-v2/models/model/faster_rcnn_inception_logos-locally-on-ubuntu.config \
    --num_train_steps=50000 --alsologtostderr
```

14. Monitor statistics with "tensorboard --logdir=PATH_TO/LogosInTheWild-v2/models/model/ 

### Export the trained Faster R-CNN and test Logo detection

``` bash
# From tensorflow/models/research/ directory
CHECKPOINT_NUMBER= Number from "model.ckpt-${CHECKPOINT_NUMBER}.meta"
python object_detection/export_inference_graph.py \
    --input_type=image_tensor \
    --pipeline_config_path=PATH_TO/LogosInTheWild-v2/models/model/faster_rcnn_inception_logos-locally-on-ubuntu.config \
    --trained_checkpoint_prefix=PATH_TO/LogosInTheWild-v2/models/model/model.ckpt-${CHECKPOINT_NUMBER} \
    --output_directory=PATH_TO/LogosInTheWild-v2/export
```

15. Open Logo Capstone Project/adjusted_object_detection_tutorial.ipynb in a jupyter notebook, adjust the paths and execute the cells.
