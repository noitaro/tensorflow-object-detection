# tensorflow-object-detection

## How to
https://noitalog.tokyo/tensorflow-object-detection/

## Docker
```
# Dockerイメージ作成
docker build -f Dockerfile -t od-1_15_2_gpu .
```
```
# Dockerコンテナ作成
docker run -v D:\tensorflow\pokego:/home/tensorflow/models/research/pokego -p 10000:6006 -it od-1_15_2_gpu
```

## Create Pascal to TFRecord
```
# 訓練データの変換
python object_detection/dataset_tools/create_pascal_tf_record.py \
--label_map_path=./pokego/tf_label_map.pbtxt \
--data_dir=./pokego --year=VOC2012 --set=train \
--output_path=./pokego/pascal_train.record
```
```
# 検証データの変換
python object_detection/dataset_tools/create_pascal_tf_record.py \
--label_map_path=./pokego/tf_label_map.pbtxt \
--data_dir=./pokego --year=VOC2012 --set=val \
--output_path=./pokego/pascal_val.record
```

## Learning
```
python object_detection/model_main.py \
--pipeline_config_path="./pokego/ssd_mobilenet_v1_coco.config" \
--model_dir="./pokego/SaveModel" \
--alsologtostderr
```

## TensorBoard
```
tensorboard --port 6006 --logdir="./pokego/SaveModel"
```
### View
http://localhost:10000/

## Export TFLite SSD Graph
```
python object_detection/export_tflite_ssd_graph.py \
--pipeline_config_path="./pokego/ssd_mobilenet_v1_coco.config" \
--trained_checkpoint_prefix="./pokego/SaveModel/model.ckpt-1436" \
--output_directory="./pokego/OutputModel" \
--add_postprocessing_op=true
```

## Tflite Convert
```
tflite_convert \
--output_file="./pokego/OutputModel/pokego.tflite" \
--graph_def_file="./pokego/OutputModel/tflite_graph.pb" \
--inference_type=QUANTIZED_UINT8 \
--input_arrays=normalized_input_image_tensor \
--input_shapes=1,300,300,3 \
--output_arrays='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3' \
--default_ranges_min=0 \
--default_ranges_max=6 \
--mean_values=128 \
--std_dev_values=128 \
--allow_custom_ops
```

## Object Detector Metadata Writer
```
python ./pokego/object_detector_Metadata_Writer.py
```

## Directory Tree
```
 📂pokego
 ┣📂Data
 ┃ ┗📂JPEGImages
 ┃   ┣📄image_0001.jpg
 ┃   ┣📄image_0002.jpg
 ┃   ┃・・・
 ┃   ┗📄image_0038.jpg
 ┣📂OutputModel
 ┃ ┣📄pokego.tflite
 ┃ ┣📄pokego_metadata.tflite
 ┃ ┣📄tflite_graph.pb
 ┃ ┗📄tflite_graph.pbtxt
 ┣📂SaveModel
 ┃ ┣📂eval_0
 ┃ ┣📄checkpoint
 ┃ ┣📄graph.pbtxt
 ┃ ┣📄model.ckpt-0.data-00000-of-00001
 ┃ ┣📄model.ckpt-0.index
 ┃ ┣📄model.ckpt-0.meta
 ┃ ┣📄model.ckpt-1436.data-00000-of-00001
 ┃ ┣📄model.ckpt-1436.index
 ┃ ┗📄model.ckpt-1436.meta
 ┣📂VOC2012
 ┃ ┣📂Annotations
 ┃ ┃ ┣📄image_0001.xml
 ┃ ┃ ┣📄image_0002.xml
 ┃ ┃ ┃・・・
 ┃ ┃ ┗📄image_0038.xml
 ┃ ┗📂ImageSets
 ┃   ┗📂Main
 ┃     ┣📄aeroplane_train.txt
 ┃     ┗📄aeroplane_val.txt
 ┣📄Dockerfile
 ┣📄labels.txt
 ┣📄object_detector_Metadata_Writer.py
 ┣📄pascal_train.record
 ┣📄pascal_val.record
 ┣📄ssd_mobilenet_v1_coco.config
 ┗📄tf_label_map.pbtxt
```
