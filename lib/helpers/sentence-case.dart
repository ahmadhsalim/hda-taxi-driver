String getSentenceCaseFromDashed(String word, {String separator: ' '}) {
  List<String> _words = word.split('-');

  _words = _words
      .map((w) =>
          '${w.substring(0, 1).toUpperCase()}${w.substring(1).toLowerCase()}')
      .toList();

  return _words.join(separator);
}
