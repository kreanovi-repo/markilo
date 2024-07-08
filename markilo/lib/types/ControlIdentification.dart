class CI {
  static const int UNDEFINED = 0;
  static const int CHASSIS = 1;
  static const int BOTTOM_DRAWER = 2;
  static const int TOP_DRAWER = 3;
  static const int TUBE_PLACEMENT = 4;
  static const int SLAG = 5;
  static const int WASHED = 6;
  static const int SEALED = 7;
  static const int PAINTWORK = 8;
  static const int PAINTTHICKNESS = 9;
  static const int TERMINATION = 10;
  static const int OVERALL_CONTROL = 11;
  static const int CONTROLLED = 12;

  getControlName(int id) {
    String ret = '';

    switch (id) {
      case UNDEFINED:
        ret = 'Undefined';
        break;
      case CHASSIS:
        ret = 'Chasis';
        break;
      case BOTTOM_DRAWER:
        ret = 'Cajón inferior';
        break;
      case TOP_DRAWER:
        ret = 'Cajón superior';
        break;
      case TUBE_PLACEMENT:
        ret = 'Colocación de tubo';
        break;
      case SLAG:
        ret = 'Escoriado';
        break;
      case WASHED:
        ret = 'Lavado';
        break;
      case SEALED:
        ret = 'Sellado';
        break;
      case PAINTWORK:
        ret = 'Pintura';
        break;
      case PAINTTHICKNESS:
        ret = 'Espesores de pintura';
        break;
      case TERMINATION:
        ret = 'Terminación';
        break;
      case OVERALL_CONTROL:
        ret = 'Control general';
        break;
      case CONTROLLED:
        ret = 'Controlado';
        break;
    }

    return ret;
  }
}
