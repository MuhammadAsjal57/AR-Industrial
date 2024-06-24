import 'package:ar_industrial/Models/MCQ_model.dart';
import 'package:ar_industrial/Models/user_model.dart';
import 'package:ar_industrial/core/utils/dialoge_constant.dart';
import 'package:ar_industrial/core/utils/size_utils.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  double _rating=0;
  TextEditingController _reviewController=TextEditingController();
  List<String?> userAnswers = List.filled(mcqs.length, null);

  int currentQuestionIndex = 0;
  bool get isSubmitDisabled {
    return userAnswers[currentQuestionIndex] == null;
  }
  void _nextQuestion() {
    setState(() {
      currentQuestionIndex++;
    });
  }

  
  

  void _submitQuiz() async {
    int score = 0;
    for (int i = 0; i < mcqs.length; i++) {
      if (userAnswers[i] == mcqs[i].correctAnswer) {
        score++;
      }
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Result'),
        content:  Text('Your score: $score/${mcqs.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _feedback();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
    void _feedback() async{
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rate this App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Rating: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 30,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // Handle rating update
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Add a review (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: ()async {
                if (_rating != null || _reviewController.text.isNotEmpty) {
              DialogConstant.showLoading(context);
               final rating = _rating; // Get the rating value
            final review = _reviewController.text; // Get the review text

            // Save rating and review data to Firestore
            try {
              await FirebaseFirestore.instance.collection('reviews').add({
                'rating': rating,
                'review': review,
                'uId':UserModel.userModel!.uId!
              });
                Navigator.of(context).pop(); // Cl
                Navigator.of(context).pop(); // C
                DialogConstant.showSnackBar(context);
              print('Review submitted successfully!');
            } catch (e) {
               Navigator.of(context).pop(); // Cl
              DialogConstant.showSnackBar2(context,e.toString());
              print('Error submitting review: $e');
            }
                }
           
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Training'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${mcqs.length}:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              mcqs[currentQuestionIndex].question,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                mcqs[currentQuestionIndex].options.length,
                (index) {
                  return RadioListTile<String?>(
                    title: Text(mcqs[currentQuestionIndex].options[index]),
                    value: mcqs[currentQuestionIndex].options[index],
                    groupValue: userAnswers[currentQuestionIndex],
                    onChanged: (String? value) {
                      setState(() {
                        userAnswers[currentQuestionIndex] = value;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: isSubmitDisabled ? null : (currentQuestionIndex < mcqs.length - 1 ? _nextQuestion : _submitQuiz),
                child: Text(currentQuestionIndex < mcqs.length - 1 ? 'Next Question' : 'Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}