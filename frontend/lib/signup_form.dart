// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unused_field, unrelated_type_equality_checks, avoid_print

import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/login_form.dart';
import 'controllers/userController.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final RegisterController _registerController = RegisterController();
  final LoginController _loginController = LoginController();

  String _passwordValue = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _name;
  TextEditingController? _lastname;
  TextEditingController? _phone;
  TextEditingController? _email;
  TextEditingController? _usuario;
  TextEditingController? _role;
  String? _selectedRole;
  bool _aceptadoTerminos = false;
  bool _aceptadaPolitica = false;
  bool _isCheckedusuario = false;
  bool _isCheckedconductor = false;
  TextEditingController? _password;
  TextEditingController? _confirmPassword;
  final Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(
            16.0), // Aquí se establece el padding del Container
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 17.0),
                        child: Text(
                          'Crea una cuenta en UPB-Car',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _name,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Por favor, ingrese un nombre';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Nombre',
                    labelStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (value) => {_data['name'] = value},
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _lastname,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Por favor, ingrese un apellido';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Apellido',
                    labelStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (value) => {_data['lastname'] = value},
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _phone,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Por favor, ingrese un número de teléfono';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Número de teléfono',
                    labelStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (value) => {_data['phone'] = value},
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _email,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Por favor, ingrese un correo electrónico';
                    }
                    if (!input.contains('@')) {
                      return 'Por favor, introduce una dirección de correo electrónico válida';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Correo',
                    labelStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (value) => {_data['email'] = value},
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _password,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Por favor, ingrese una contraseña';
                    }
                    if (input.length < 6) {
                      return 'Su contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (value) =>
                      {_data['password'] = value, _passwordValue = value},
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _confirmPassword,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Por favor ingrese una contraseña';
                    }
                    if (input != _passwordValue) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Confirmar contraseña',
                    labelStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                ),
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Selecciona un tipo de usuario',
                      ),
                      value: _selectedRole,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue!;
                          if (_selectedRole == "Pasajero") {
                            _isCheckedusuario = true;
                            _isCheckedconductor = false;
                            _data["role"] = "usuario";
                          } else if (_selectedRole == "Conductor") {
                            _isCheckedusuario = false;
                            _isCheckedconductor = true;
                            _data["role"] = "conductor";
                          } else {
                            _isCheckedusuario = false;
                            _isCheckedconductor = false;
                            _data["role"] = null;
                          }
                        });
                      },
                      items: <String>['', 'Pasajero', 'Conductor']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                _registerController.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          _mostrarTerminosYCondiciones();
                        },
                        child: const Text(
                          'Crear cuenta',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                _registerController.errorMessage != ""
                    ? Text(
                        _registerController.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      )
                    : Container(),
                TextButton(
                  child: const Text('¿Ya tienes cuenta? Inicia sesión',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (const LoginPage())));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _mostrarTerminosYCondiciones() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Términos y Condiciones'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    '''Los presentes Términos y Condiciones regulan el acceso o uso que usted haga, como persona, desde cualquier lugar de la República de Colombia, de aplicaciones, páginas web, contenido, productos y servicios ofrecidos por la aplicación UPB-Car.

Mediante su acceso y uso de los servicios de la aplicación, usted acuerda vincularse jurídicamente por estos Términos y Condiciones, que establecen una relación contractual y comercial entre usted y UPB-Car. Si usted no acepta estos Términos y Condiciones, no podrá acceder o usar los servicios. UPB-Car podrá poner fin de inmediato a estas Condiciones o cualquiera de los Servicios respecto de usted o, en general, dejar de ofrecer o denegar el acceso a los Servicios o cualquier parte de ellos, en cualquier momento y por cualquier motivo.

UPB-Car podrá modificar las Condiciones relativas a los Servicios cuando lo considere oportuno. Las modificaciones serán efectivas después de la publicación por parte de UPB-Car de dichas condiciones actualizadas en esta ubicación o las políticas modificadas o condiciones adicionales o suplementarias sobre el Servicio aplicable. Su acceso o uso continuado de los Servicios después de dicha publicación constituye su consentimiento a vincularse por las Condiciones y sus modificaciones.


1.	Servicios:

Acceso a la Aplicación.
Sujeto al cumplimiento de estas Condiciones, UPB-Car le otorga a usted un derecho de uso limitado, no exclusivo, no sublicenciable, revocable, no transferible para el acceso y uso de la aplicación de UPB-Car en su dispositivo personal solo en relación con su uso de los Servicios; y el acceso y uso de cualquier contenido, información y material relacionado que pueda ponerse a su disposición a través de los servicios, en cada caso solo para su uso personal, no comercial. UPB-Car se reserva cualquier derecho que no haya sido expresamente otorgado por el presente.
Prestación de los Servicios.
Usted reconoce que los servicios podrán ponerse a disposición bajo marcas u opciones asociadas con el servicio de transporte de pasajeros bajo la modalidad de taxi y/u otras opciones disponibles a través de los servicios, según corresponda. Asimismo, usted reconoce que los servicios podrán ponerse a disposición bajo dicha marca u opciones por o en relación con terceros proveedores independientes, incluidas terceras plataformas tecnológicas habilitadas para la intermediación digital de servicios de transporte u otros similares.
Titularidad.
Los Servicios y todos los derechos relativos a estos son y permanecerán de la propiedad de UPB-Car. Ninguna de estas condiciones ni su uso de los servicios le transfieren u otorgan ningún derecho: sobre o en relación con los servicios, excepto en cuanto a su acceso a la aplicación mencionado anteriormente; o bien a utilizar o mencionar en cualquier modo a los nombres de empresa, logotipos, nombres de producto y servicio, marcas comerciales o marcas de servicio de UPB-Car.


2.  Su uso de los Servicios

Cuentas de usuario.
Con el fin de usar la mayor parte de los aspectos de los servicios, usted debe registrarse y mantener activa una cuenta personal de usuario de los servicios. El registro de la cuenta requiere que comunique a UPB-Car determinada información personal, que podría incluir, entre otros, su nombre, número de teléfono móvil. Usted se compromete a mantener la información en su cuenta de forma exacta, completa y actualizada. Si no mantiene la información de la cuenta de forma exacta, completa y actualizada, incluso el tener un método de pago inválido o que haya vencido, podrá resultar en su imposibilidad para acceder y utilizar los servicios o en la resolución por parte de UPB-Car de estas condiciones celebradas con usted. Usted es responsable de toda la actividad que ocurre en su cuenta y se compromete a mantener en todo momento de forma segura y secreta el nombre de usuario y la contraseña de su cuenta. A menos que UPB-Car permita otra cosa por escrito, usted solo puede poseer una cuenta.
Requisitos y conducta del usuario.
Usted no podrá ceder o transferir de otro modo su cuenta a cualquier otra persona o entidad. Usted acuerda cumplir con todas las leyes aplicables al utilizar los servicios y solo podrá utilizar los servicios con fines legítimos. En el uso de los servicios, no causará estorbos, molestias, incomodidades o daños a la propiedad de terceros. En algunos casos, se le podrá requerir que facilite un documento de identidad u otro elemento de verificación de identidad para el acceso o uso de los servicios, y usted acepta que se le podrá denegar el acceso o uso de los servicios si se niega a facilitar el documento de identidad o el elemento de verificación de identidad.

Contenido proporcionado por el Usuario.
UPB-Car podrá, a su sola discreción, permitirle, cuando considere oportuno, que envíe, cargue, publique o de otro modo ponga a disposición de UPB-Car, a través de los servicios, contenido e información de texto, audio y/o visual, incluidos comentarios y opiniones relativos a los servicios, iniciación de peticiones de apoyo, así como presentación de admisiones para competiciones y promociones (“contenido de usuario”). Todo contenido de usuario facilitado por usted seguirá siendo de su propiedad. No obstante, al proporcionar contenido de usuario a UPB-Car, usted otorga a UPB-Car, una licencia mundial, perpetua, irrevocable, transferible, libre de regalías, con derecho a sublicenciar, usar, copiar, modificar, crear obras derivadas, distribuir, exhibir públicamente, presentar públicamente o de otro modo explotar de cualquier manera dicho contenido de usuario en todos los formatos y canales de distribución, conocidos ahora o ideados en un futuro (incluidos en relación con los servicios y el negocio de UPB-Car y en sitios y servicios de terceros incluyendo terceras plataformas tecnológicas habilitadas para la intermediación de servicios de transporte), sin más aviso o consentimiento de usted y sin requerirse el pago a usted o a cualquier otra persona o entidad.

Usted declara y garantiza que es el único y exclusivo propietario de todo el contenido de usuario o que tiene todos los derechos, licencias, consentimientos y permisos necesarios para otorgar a UPB-Car la licencia al contenido de usuario como establecido anteriormente; ni el contenido de usuario ni su presentación, carga, publicación o puesta a disposición de otro modo de dicho contenido de usuario, ni el uso por parte de UPB-Car del Contenido de Usuario como está aquí permitido, infringirán, malversarán o violarán la propiedad intelectual o los derechos de propiedad de un tercero o los derechos de publicidad o privacidad o resultarán en la violación de cualquier ley o reglamento aplicable. 
Usted acuerda no proporcionar Contenido de Usuario que sea difamatorio, calumnioso, que incite al odio, violento, obsceno, pornográfico, ilícito o de otro modo ofensivo, como determine UPB-Car, a su sola discreción, tanto si dicho material pueda estar protegido o no por la ley. UPB-Car podrá, a su sola discreción y en cualquier momento y por cualquier motivo, sin avisarle previamente, revisar, controlar o eliminar Contenido de Usuario, pero sin estar obligada a ello. 
Acceso a la red y dispositivos.  Usted es responsable de obtener el acceso a la red de datos necesaria para utilizar los Servicios. Su proveedor de servicios inalámbricos puede aplicar cargos por datos y mensajes al acceder o utilizar sus servicios desde su dispositivo inalámbrico, y usted es responsable de estos cargos y cargos. Usted es responsable de obtener y actualizar el hardware o los dispositivos compatibles necesarios para acceder y utilizar los Servicios y las Aplicaciones y las actualizaciones relacionadas. UPB-Car no garantiza que el Servicio o cualquier parte del mismo funcionará con cualquier hardware o dispositivo en particular. Además, el Servicio puede estar sujeto a interrupciones o retrasos inherentes al uso de Internet y las comunicaciones electrónicas.'''),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Rechazar'),
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                _aceptadoTerminos =
                    true; // marcar los términos y condiciones como aceptados
                _mostrarPoliticaPrivacidad();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarPoliticaPrivacidad() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Política de privacidad'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('''

Al usar UPB-Car, sus datos están protegidos con nosotros. Esta política describe nuestras describe la información personal recopilada por UPB-Car, y cómo esta utiliza y protege los datos de los usuarios de nuestra aplicación móvil. 
Esta es aplicada a todos los clientes del aplicativo, ya sean los “pasajeros”, aquellos que solicitan servicios de transporte a través de su cuenta, o “conductores”, los usuarios que brindan dichos servicios de movilidad a los pasajeros por medio de sus automóviles. 


Datos Recopilados

UPB-Car recopila la siguiente información de los usuarios:
Datos de registro y perfil del usuario: Recopilamos el nombre completo del usuario para poder identificarlo y comunicarnos con él de manera efectiva y utilizar esta información para personalizar la experiencia del usuario. Además, se recopilan datos como el número de teléfono y la dirección de correo electrónico del usuario para poder enviarle información relacionada con el uso de la aplicación y confirmación de su cuenta. 
Información del conductor: Se solicitarán algunos datos especiales de la persona para su aprobación como conductor de la aplicación. Estos datos pueden incluir una foto de su licencia de conducir válida, información de su vehículo de transporte como su placa, su color, su modelo; documento de identidad, historial de conducción, además de una foto de su rostro.
(Información de tarjeta de crédito: Si el usuario decide guardar una tarjeta de crédito en su perfil de UPB-Car, recopilaremos la información necesaria para procesar los pagos de las reservas realizadas a través de la aplicación.)

Ubicación: La aplicación de UPB-Car recopila información geográfica precisa o aproximada de los dispositivos móviles de los usuarios con el fin de mejorar la experiencia de los viajes. En el caso de los pasajeros, se utiliza su ubicación para solicitar un servicio de transporte y determinar la ubicación del punto de encuentro. Por su parte, los conductores utilizan esta información para mostrar su distancia del punto de encuentro. A través de este proceso, se pueden unir ambas coordenadas y calcular el costo del viaje de manera efectiva.

Información de viajes y transacciones: Recopilamos datos sobre el uso de nuestros servicios, incluyendo las transacciones realizadas. Esta información incluye detalles acerca del viaje, como la fecha y hora en que se realizó, las direcciones del punto de partida y destino del viaje, la distancia recorrida y los artículos pedidos. Además, también recopilamos información sobre las transacciones de pago, como el monto cobrado y el método de pago utilizado.


¿Cómo usamos sus datos personales?

Utilizamos la información recolectada para los siguientes fines:
•	Proporcionar los servicios de la aplicación: Utilizamos la información que recopilamos para crear sus cuentas personales, además de procesar las reservas de transporte realizadas a través de la aplicación, para enviar confirmaciones de viaje y para procesar los pagos de los mismos.
•	Personalización de la experiencia del usuario: Utilizamos la información que recopilamos para personalizar la experiencia del usuario dentro de la aplicación. Por ejemplo, podemos utilizar la información sobre la ubicación del usuario para mostrar las opciones de transporte disponibles en su área.
•	Mantener un ambiente seguro: Utilizamos la información que recopilamos acerca de los conductores para verificar que cumplan con los requerimientos legales para prevenir problemas de seguridad con todos los usuarios.


¿Cómo compartimos su información?

UPB-Car puede compartir la información que recopila de los usuarios en las siguientes circunstancias:
•	Con conductores: Si el pasajero utiliza la aplicación para solicitar un servicio de transporte, podemos compartir su nombre, número de teléfono y ubicación con el proveedor de transporte correspondiente para facilitar la prestación del servicio.
•	Con pasajeros: Al aceptar un viaje, el usuario recibirá de la aplicación los datos de nombre del conductor, su calificación y los datos básicos del carro (Color, placa, modelo).
•	Por motivos legales: UPB-Car puede compartir los datos de los usuarios si así lo exige la ley o solicitud gubernamental vigente, o cuando la divulgación es apropiada debido a asuntos de seguridad o similares, para de esta manera proteger y defender los derechos, intereses, seguridad y protección de nuestros usuarios.

Contacto
Si tiene preguntas o comentarios sobre esta Política de Privacidad o sobre cómo UPB-Car recopila, utiliza o protege la información personal, puede comunicarse con nosotros por correo electrónico a miguel.mendoza.2020@upb.edu.co.


'''),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Rechazar'),
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                _aceptadaPolitica = true;
                _submit();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (_isCheckedconductor == false && _isCheckedusuario == false) {
      setState(() {
        _registerController.errorMessage =
            "Debe seleccionar un tipo de usuario";
      });
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _registerController.isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        _registerController.register(_data["name"], _data["lastname"],
            _data["phone"], _data["email"], _data["password"], _data["role"]);
        _registerController.isLoading = false;
      } catch (e) {
        setState(() {
          _registerController.isLoading = false;
          _registerController.errorMessage = e.toString();
        });
      }
    }
  }
}
