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

8. In order to remove XML files without corresponding JPEG images from the Logos in the Wild dataset and du adjust brand names, run the following: 
``` bash
# From LogosInTheWild-v2/scripts directory
$ python create_clean_dataset.py --roi --in ../data --out ../cleaned-data
```
This outputs that 9,428 images and 821 brands were processed, while 1,330 JPEG files were unavailable.


### Creating TFRecord files for Tensorflow's Object Dectection API

9. For [this necessary conversion of our dataset to Tensorflow's TFRecord file format](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/preparing_inputs.md), copy the following from the Logo Capstone Project:
-- pascal_label_map.pbtxt to the LogosInTheWild-v2/data directoy, 
-- create_pascal_tf_record.py to the LogosInTheWild-v2 directoy,
-- analyze_pascal_tf_record.py to the LogosInTheWild-v2 directoy.

10.  Execute our adaption of Tensorflow's [create_pascal_tf_record.py](https://github.com/tensorflow/models/blob/master/research/object_detection/dataset_tools/create_pascal_tf_record.py) script to convert the Logos in the Wild dataset to TFRecord files:
``` bash
# From LogosInTheWild-v2 directory
$ python create_pascal_tf_record.py --data_dir=./data/voc_format --year=VOC2012  --label_map_path=./data/pascal_label_map.pbtxt --output_path=./data/
```

11. If you want to get a summary of the converted files, run
``` bash
# From LogosInTheWild-v2 directory
$ python analyze_pascal_tf_record.py --data_dir=./data/voc_format --year=VOC2012  --label_map_path=./data/pascal_label_map.pbtxt --output_path=./data/
```


### Setting up Google Bucket Storage (instead of creating TFRecord files in Step 10)

-- Install [gsutil](https://cloud.google.com/storage/docs/gsutil_install#sdk-install)

-- Download dataset from Google bucket 
``` bash
# From Logo Capstone Project directory
gsutil cp -r gs://logo-bucket-europe-west1 .
```
