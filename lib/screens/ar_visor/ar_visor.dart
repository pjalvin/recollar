import 'dart:typed_data';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as imageLib;
import 'package:recollar/util/configuration.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ArVisor extends StatefulWidget {
  final String image;
  final String token;
  const ArVisor({Key? key,required this.image, required this.token}) : super(key: key);

  @override
  _ArVisorState createState() => _ArVisorState();
}

class _ArVisorState extends State<ArVisor> {
  late ArCoreController arCoreController;
  var node;
  double _sizeNode=1.0;
  bool first =true;
  ArCoreHitTestResult ? _lastHit;
  Uint8List ? _bytesImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor AR'),
        backgroundColor: color2,
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
             enablePlaneRenderer: true,
          ),
          _lastHit!=null?Positioned(
            bottom: 10,
            width: MediaQuery.of(context).size.width,
            child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SfSlider(
                min: 0.1,
                max: 1,
                activeColor: color1,
                inactiveColor: color2.withOpacity(0.5),
                value: _sizeNode,
                interval: 0.1,
                enableTooltip: true,

                onChanged: (dynamic value){
                  _resizeImage();
                  setState(() {
                    _sizeNode=value;
                  });
                },
              )
            ],
          ),
          ):Container()
        ],
      )
    );
  }


  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }


  Future _resizeImage() async {
    var image=await decodeImageFromList(_bytesImage!);
    await arCoreController.removeNode(nodeName: "node");
    imageLib.Image thumbnail = imageLib.Image.fromBytes((image.width*_sizeNode).toInt(), (image.width*_sizeNode).toInt(), _bytesImage!.toList());
    node = ArCoreNode(
        image: ArCoreImage(bytes: thumbnail.getBytes(), width: (image.width*_sizeNode).toInt(), height: (image.height*_sizeNode).toInt(),),
        position: _lastHit!.pose.translation + vector.Vector3(0.0, 0.0, 0.0),
        rotation: _lastHit!.pose.rotation + vector.Vector4(0.0, 0.0, 0.0, 0.0),

        name: "node"

    );
    await arCoreController.addArCoreNodeWithAnchor(node);
  }
  Future _addImage(ArCoreHitTestResult hit) async {
    var res=await get(Uri.http(dotenv.env["API_URL"]??"", "${dotenv.env['API_URL_COMP'] ?? ""}/image/${widget.image}"),
    headers: {"Authorization":"Bearer "+widget.token});
    final bytes = res.bodyBytes;
    print("bytes :${res.body}");
    var image=await decodeImageFromList(bytes);
    print(image.width.toString()+"area");
      await arCoreController.removeNode(nodeName: "node");
    node = ArCoreNode(
      image: ArCoreImage(bytes: bytes, width: image.width, height: image.height,),
      position: hit.pose.translation + vector.Vector3(0.0, 0.0, 0.0),
      rotation: hit.pose.rotation + vector.Vector4(0.0, 0.0, 0.0, 0.0),
      name: "node"

    );
    await arCoreController.addArCoreNodeWithAnchor(node);
    setState(() {

      _lastHit=hit;
      _bytesImage=bytes;
    });
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addImage(hit);
  }
}
