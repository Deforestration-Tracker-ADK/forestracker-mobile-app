import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/images.dart';
import 'package:forest_tracker/logic_layer/events/add_images_event.dart';
import 'package:forest_tracker/logic_layer/states/add_image_state.dart';

class ImagesBloc extends Bloc<ImagesEvent,ImagesState>{
  final Images images;
  ImagesBloc({this.images}) : super(ImageLoading());

  @override
  Stream<ImagesState> mapEventToState(ImagesEvent event) async*{
    if(event is AddImagesEvent){
      yield AddImages(images.getImages());
    }
    if(event is SelectImagesEvent){
      yield ImageLoading();
      images.addImages(event.images);

      if(images.getImages().length>5){
        images.updateList(5);
        yield SelectMaxImages(images.getImages());
      }
      else{
        yield SelectImages(images.getImages());
      }

    }
    if(event is DeleteImageEvent){
      yield ImageLoading();
      images.deleteImage(event.imageId);
      yield DeleteImage(images.getImages());
    }
  }

}