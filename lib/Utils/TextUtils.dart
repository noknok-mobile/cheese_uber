extension  TextUtils on String{

   String replaceHTMLSpecialChars(){
      return this.trim().replaceAll("&nbsp;", " ").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replaceAll("&quot;", "\"").replaceAll("&#37;", "%");


  }


}