*&---------------------------------------------------------------------*
*& Report  Z_ALV
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  Z_ALV.

* Necesario para que funcionen las ALV
TYPE-POOLS: slis.

* Declaracion de las tablas que tendr�n la informaci�n de salida.
TYPES BEGIN OF et_final.
  INCLUDE STRUCTURE sflight.
TYPES END OF et_final.

TYPES: tt_final TYPE STANDARD TABLE OF et_final.

* Tablas internas
DATA:
      it_final TYPE STANDARD TABLE OF et_final,
      wa_data TYPE et_final.

* Declaraci�n de variables ALV.
DATA:
      e_layout    TYPE slis_layout_alv,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      e_fcat      TYPE slis_fieldcat_alv.

* Procesamiento de datos y llenado de la tabla final.
START-OF-SELECTION.
  SELECT *
    FROM sflight
    UP TO 100 ROWS
    INTO TABLE it_final.

* Se inicia el Layout
    e_layout-colwidth_optimize = 'X'.
    e_layout-zebra = 'X'.
    e_layout-window_titlebar = 'T�tulo del reporte ALV'.

* Se pone una fila por cada columna de la tabla final.
e_fcat-col_pos = '1'. "Posici�n de la columna
e_fcat-fieldname = 'CARRID'. "Nombre del campo
e_fcat-just = 'L'. "Justificaci�n
e_fcat-reptext_ddic = 'C�digo de aerol�nea'. "T�tulo de la columna
APPEND e_fcat TO it_fieldcat.

e_fcat-col_pos = '2'. "Posici�n de la columna
e_fcat-fieldname = 'CONNID'. "Nombre del campo
e_fcat-just = 'L'. "Justificaci�n
e_fcat-reptext_ddic = 'N�mero de conexi�n'. "T�tulo de la columna
APPEND e_fcat TO it_fieldcat.

* Llamar al m�dulo 'REUSE_ALV_GRID_DISPLAY'
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program = sy-repid
    is_layout = e_layout
    it_fieldcat = it_fieldcat

    TABLES
      t_outtab = it_final

    EXCEPTIONS
      program_error = 1
      OTHERS = 2
    .

IF sy-subrc <> 0.
  WRITE 'Ocurri� un error'.
ENDIF.