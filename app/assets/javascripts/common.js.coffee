String::basename = -> @substring(0, @lastIndexOf('.'))
String::extension = -> @split('.').pop()