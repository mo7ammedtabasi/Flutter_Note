import 'package:flutter/material.dart';

class ViewNotes extends StatefulWidget {
  final notes;

  const ViewNotes({super.key, this.notes});

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("View Notes",style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              child: Image.network(
                "${widget.notes['imageUrl']}",
                width: double.infinity,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
            Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  "${widget.notes['title']}",
                  style: Theme.of(context).textTheme.headline5,
                )),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                "${widget.notes['note']}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
