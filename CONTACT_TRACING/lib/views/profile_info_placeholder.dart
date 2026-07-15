import 'package:contact_tracing/utils/textStyles.dart';
import 'package:flutter/material.dart';

class ProfilePlaceHolder extends StatefulWidget {
  const ProfilePlaceHolder({super.key,required this.text,required this.title});
  final String text;
  final String title;

  @override
  State<ProfilePlaceHolder> createState() => _ProfilePlaceHolderState();
}

class _ProfilePlaceHolderState extends State<ProfilePlaceHolder> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.2)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,style: const TextStyle(color: Colors.black,fontSize: 16,),),
          const SizedBox(height: 5,),
          Text(
            widget.text,
            style:TextStyle(
              color: Colors.amber,
              fontSize: 14,
              fontWeight: FontWeight.w800
            ),
          ),
        ],
      ),
    );
  }
}
