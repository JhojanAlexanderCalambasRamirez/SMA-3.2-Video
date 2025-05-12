class ButtonMessageDecision {
  static List<String> getMessages(String videoName) {
    switch (videoName) {
      case 'Escena2':
        return [
          'Arrebatarle el teléfono y mostrarle la realidad.',
          'Dejarlo, quizás no es tan grave.',
        ];
      case 'Escena3':
        return [
          'Guiarla con un plan claro y concreto.',
          'Ignorarla y seguir adelante.',
        ];
      case 'Escena4':
        return [
          'Usar el reloj para disipar la niebla y despertar a los estudiantes.',
          'Ignorarla y seguir adelante.',
        ];
      default:
        return ['', '']; 
    }
  }
}
