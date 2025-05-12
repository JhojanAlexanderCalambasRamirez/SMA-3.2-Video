class ButtonMessageDecision {
  static List<String> getMessages(String videoName) {
    switch (videoName) {
      case 'Escena2':
        return [
          'Arrebatarle el teléfono y mostrarle la realidad.', //Opcion Positiva
          'Dejarlo, quizás no es tan grave.', //Opcion Negativa
        ];
      case 'Escena3':
        return [
          'Guiarla con un plan claro y concreto.', //Opcion Positiva
          'Ignorarla y seguir adelante.', //Opcion Negativa
        ];
      case 'Escena4':
        return [
          'Usar el reloj para disipar la niebla y despertar a los estudiantes.', //Opcion Positiva
          'Ignorarla y seguir adelante.', //Opcion Negativa
        ];
      default:
        return ['', '']; 
    }
  }
}
