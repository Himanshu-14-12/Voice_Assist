import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_assistant/secret.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];
  Future<String> isArtprompt(String prompt) async {
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                'role': 'user',
                'content':
                    'Does this message want to generate an AI picture, image, art or anything similar?  $prompt . Simply answer with yes or no.',
              }
            ]
          }));
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        switch (content) {
          case 'Yes':
          case 'yes':
          case 'yes. ':
          case 'Yes. ':
          case 'YES. ':
            final res = await dallE(prompt);
            return res;
          default:
            final res = await chatGPT(prompt);
            return res;
        }
      }
      return 'An internal erro occured.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPT(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": messages,
          }));
      //print(res.body);

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal erro occured.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallE(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIKey',
          },
          body: jsonEncode({
            'prompt': prompt,
            'n': 1,
          }));
      //print(res.body);

      if (res.statusCode == 200) {
        String imgUrl = jsonDecode(res.body)['data'][0]['url'];
        imgUrl = imgUrl.trim();
        messages.add({
          'role': 'assistant',
          'content': imgUrl,
        });
        return imgUrl;
      }
      return 'An internal erro occured.';
    } catch (e) {
      return e.toString();
    }
  }
}
