import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourQueriesScreen extends StatefulWidget {
  const YourQueriesScreen({Key? key}) : super(key: key);

  @override
  State<YourQueriesScreen> createState() => _YourQueriesScreenState();
}

class _YourQueriesScreenState extends State<YourQueriesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Your Queries"),
          centerTitle: true,
          backgroundColor: Color(0xfff6ab36).withOpacity(0.9),
        ),
        body: Steps()
    );
  }
}
class Step {
  Step(
      this.title,
      this.subject,
      this.body,
      [this.isExpanded = false]
      );
  String title;
  String subject;
  String body;
  bool isExpanded;
}

List<Step> getSteps() {
  return [
    Step('Query | Ticket no. xhf789jnf', "Regarding Courier Delivery",'Install Flutter development tools according to the official documentation.'),
    // Step('Step 1: Create a project', "",'Open your terminal, run `flutter create <project_name>` to create a new project.',),
  ];
}

class Steps extends StatefulWidget {
  const Steps({Key? key}) : super(key: key);
  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  List<Step> _steps = [];

  void getQueries() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = await prefs.getString('userID')??'';
    var order = await Requests.get('http://64.227.160.250/api/query/${userID}',
        body: {
          'user':userID,
        },
        bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    order.raiseForStatus();
    dynamic orderID = order.json();
    List<Step> _queries = [];
    for(int i=0;i<orderID.length;i++){
      print(orderID[i]);
      _queries.add(Step(orderID[i]['subject'],orderID[i]['type'],orderID[i]['message'][0]['message'],));
    }
    setState(() {
      _steps.addAll(_queries);
    });
    print(_steps);
  }


  @override
  void initState() {
    super.initState();
    getQueries();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
        child: _renderSteps(),
      ),
    );
  }
  Widget _renderSteps() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _steps[index].isExpanded = !isExpanded;
        });
      },
      children: _steps.map<ExpansionPanel>((Step step) {
        return ExpansionPanel(
          backgroundColor: Colors.brown.shade200,
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(

              contentPadding: EdgeInsets.only(left: 15.w,top: 7.h,bottom: 7.h),
              title: Text(step.title,style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Padding(
                  padding: EdgeInsets.only(top: 5.h,left: 5.w),
                  child: Text(step.subject)),
            );
          },
          body: ListTile(
            title: Text(step.body),
            contentPadding: EdgeInsets.only(left: 15.w),
          ),
          isExpanded: step.isExpanded,
        );
      }).toList(),
    );
  }
}