import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:splitip/Utils/constants.dart';
import 'package:splitip/Utils/extensions.dart';
import 'package:splitip/Utils/spaces.dart';
import 'package:splitip/answermodel.dart';
import 'package:splitip/cubit/splitip_cubit.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController people = TextEditingController();
  TextEditingController bill = TextEditingController();
  TextEditingController tip = TextEditingController();
  String t = "".replaceAllMapped(
      new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
        content: Text(
          'Please provide a value',
          style: TextStyle(fontSize: context.width() * .035),
        ),
        backgroundColor: primary,
        duration: Duration(seconds: 5));
    int count = BlocProvider.of<SplitipCubit>(context).question;
    void increment(TextEditingController type) {
      int count = BlocProvider.of<SplitipCubit>(context).question;
      print(count);
      if (count == 4) return;
      FocusScope.of(context).requestFocus(FocusNode());
      if (type.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      BlocProvider.of<SplitipCubit>(context).questioning = count + 1;
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: context.height(.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: count != 1,
                    child: IconButton(
                      onPressed: () {
                        int count =
                            BlocProvider.of<SplitipCubit>(context).question;

                        if (count == 1) return;
                        FocusScope.of(context).requestFocus(FocusNode());
                        BlocProvider.of<SplitipCubit>(context).questioning =
                            count - 1;
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: primary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh_rounded, color: primary),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      bill.clear();
                      people.clear();
                      tip.clear();
                      BlocProvider.of<SplitipCubit>(context).questioning = 1;
                    },
                  )
                ],
              ),
            ),
            BlocConsumer<SplitipCubit, SplitipState>(builder: (context, state) {
              if (state is SplitipQuestion1) {
                return Question(
                  image: 'table.jpg',
                  question: 'How many people ate at the table?',
                  controller: people,
                  onPressed: () => increment(people),
                );
              } else if (state is SplitipQuestion2) {
                return Question(
                  image: 'bill.png',
                  question: 'How much is the total bill?',
                  controller: bill,
                  onPressed: () => increment(bill),
                );
              } else if (state is SplitipQuestion3) {
                return Question(
                  image: 'waiter.jpeg',
                  question:
                      'How many percent(%) do you want to tip? It is customary to tip between 15-25%',
                  controller: tip,
                  onPressed: () => increment(tip),
                );
              } else if (state is SplitipResult) {
                return Answer(
                  bill: bill.text,
                  people: people.text,
                  tip: tip.text,
                );
              } else
                return Container();
            }, listener: (context, state) {
              if (state is Error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Error",
                    style: TextStyle(
                      fontSize: context.width() * .035,
                    ),
                  ),
                  backgroundColor: white,
                  duration: Duration(seconds: 5),
                ));
              }
            })
          ],
        ),
      ),
    );
  }
}

class Question extends StatelessWidget {
  final String image;
  final String question;
  final TextEditingController controller;
  final Function onPressed;

  Question(
      {required this.image,
      required this.controller,
      required this.question,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.width(.02), vertical: context.height(.01)),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/$image',
              height: context.height(.3),
            ),
            Hspace(context.height(.05)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$question",
                style: TextStyle(
                    // color: white,
                    fontSize: context.width(.05),
                    fontWeight: FontWeight.w800),
              ),
            ),
            Hspace(context.height(.02)),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(right: context.width(.12)),
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                      fontSize: context.width(.045),
                      color: primary,
                      fontWeight: FontWeight.w600),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [amountValidator],
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary, width: 3)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2))),
                ),
              ),
            ),
            Hspace(context.height(.075)),
            Stack(alignment: AlignmentDirectional.center, children: [
              Container(
                height: context.width(.12),
                width: context.width(.12),
                decoration:
                    BoxDecoration(color: primary, shape: BoxShape.circle),
              ),
              IconButton(
                  onPressed: () => onPressed(),
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: white,
                  ))
            ]),
          ],
        ),
      ),
    );
  }
}

class Answer extends StatelessWidget {
  final String people;
  final String bill;
  final String tip;

  Answer({required this.bill, required this.people, required this.tip});
  @override
  Widget build(BuildContext context) {
    Answermodel answermodel = Functions.calculate(
        bill: double.parse(bill),
        people: int.parse(people),
        tip: double.parse(tip));

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: context.height(.05), horizontal: context.width(.05)),
      child: Column(
        children: [
          Row(
            children: [
              Text1('Bill'),
              Text2(answermodel.bill),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          Row(
            children: [
              Text1("Total Person(s)"),
              Text2(double.parse(answermodel.people.toString())),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          Row(
            children: [
              Text1("Total Bill (with tip)"),
              Text2(answermodel.totalBill),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          Row(
            children: [
              Text1("Waiter's Tip"),
              Text2(answermodel.waitersTip),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          Row(
            children: [
              Text1("Each Person(s) Pays"),
              Text2(answermodel.eachBill),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          Hspace(context.height(.1)),
          ElevatedButton(
            onPressed: () {
              Share.share(
                "Bill:    ${answermodel.bill.round()} \nTotal Person(s):    ${answermodel.people.round()} \nTotal Bill (with tip):    ${answermodel.totalBill.round()} \nWaiter's Tip:    ${answermodel.waitersTip.round()} \nEach Person(s) Pays:    ${answermodel.eachBill.round()}"
                    .replaceAllMapped(
                        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},'),
              );
            },
            child:
                Text("Share", style: TextStyle(fontSize: context.width(.04))),
          )
        ],
      ),
    );
  }
}

class Text2 extends StatelessWidget {
  const Text2(
    this.value,
  );

  final double value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
          "${value.round()}".replaceAllMapped(
              new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},'),
          style: TextStyle(
              fontSize: context.width(.04),
              color: primary,
              fontWeight: FontWeight.w600)),
    );
  }
}

class Text1 extends StatelessWidget {
  final String title;
  Text1(this.title);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Text(
        "$title:",
        style: TextStyle(
            fontSize: context.width(.045), fontWeight: FontWeight.w700),
      ),
    );
  }
}

class Functions {
  static Answermodel calculate(
      {required int people, required double bill, required double tip}) {
    var waitersTip = (tip / 100) * bill;
    var total = waitersTip + bill;
    var each = total / people;
    return Answermodel(
        people: people,
        bill: bill,
        tipPercent: tip,
        waitersTip: waitersTip,
        totalBill: total,
        eachBill: each);
  }
}
