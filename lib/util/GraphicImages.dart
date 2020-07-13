
class GraphicImages{

  static List<Map<String, String>> listGraphics(){
    List<Map<String, String>> listGraphics = [];
    listGraphics.add(optionBar);
    listGraphics.add(optionBarHorizontal);
    listGraphics.add(optionLineBar);
    listGraphics.add(optionLine);
    listGraphics.add(optionPie);
    listGraphics.add(optionPieLegend);
    return listGraphics;
  }

  static Map<String, String> optionBar = {
    "url": "images/graphic_bar.png",
    "title": "Barras",
    "type": "bar",
  };

  static Map<String, String> optionBarHorizontal = {
    "url": "images/graphic_bar_horizontal.png",
    "title": "Barras Horizontal",
    "type": "barHorizontal",
  };

  static Map<String, String> optionLineBar = {
    "url": "images/graphic_Combo-LineBar.png",
    "title": "Linha e Barra",
    "type": "lineBar",
  };

  static Map<String, String> optionLine = {
    "url": "images/graphic_Line.png",
    "title": "Linha",
    "type": "line",
  };

  static Map<String, String> optionPie = {
    "url": "images/graphic_Pie.png",
    "title": "Pizza",
    "type": "pie",
  };

  static Map<String, String> optionPieLegend = {
    "url": "images/graphic_Pie-Legend.png",
    "title": "Pizza Legendada",
    "type": "pieLegend",
  };
}