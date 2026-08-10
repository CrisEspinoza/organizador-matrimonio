# Guía para activar la sincronización en la nube (Firebase)

Esta guía te lleva paso a paso para que el organizador guarde los datos en internet
y se sincronice **entre todos los dispositivos** (tu computador, el celular de Keyla, etc.),
con un **login real** de correo y contraseña. Todo es **gratis** para el uso de un matrimonio.

No necesitas saber programar. Solo sigue los pasos y, al final, copiar y pegar un bloque de texto.

---

## Paso 1 — Crear el proyecto en Firebase

1. Entra a **https://console.firebase.google.com** e inicia sesión con tu cuenta de Google.
2. Haz clic en **"Crear un proyecto"** (o "Add project").
3. Ponle un nombre, por ejemplo: `matrimonio-keyla-cristian`.
4. En el paso de Google Analytics puedes **desactivarlo** (no lo necesitamos). Clic en **Crear proyecto**.
5. Espera unos segundos y clic en **Continuar**.

---

## Paso 2 — Registrar la aplicación web y copiar la configuración

1. En la pantalla principal del proyecto, haz clic en el ícono **`</>`** (Web).
2. Ponle un apodo, por ejemplo `organizador`, y clic en **Registrar app**.
   - **No** marques "Firebase Hosting" por ahora.
3. Firebase te mostrará un bloque de código parecido a este:

   ```js
   const firebaseConfig = {
     apiKey: "AIzaSyXXXXXXXXXXXXXXXXX",
     authDomain: "matrimonio-keyla-cristian.firebaseapp.com",
     projectId: "matrimonio-keyla-cristian",
     storageBucket: "matrimonio-keyla-cristian.appspot.com",
     messagingSenderId: "123456789",
     appId: "1:123456789:web:abcdef123456"
   };
   ```

4. **Copia ese bloque completo.** Lo vas a pegar más adelante (Paso 6).

> Nota: estos valores son públicos por diseño; no son la contraseña. La seguridad la ponen
> el login y las reglas del Paso 5.

---

## Paso 3 — Activar el login (Authentication)

1. En el menú de la izquierda: **Compilación → Authentication** → botón **Comenzar**.
2. En la pestaña **Sign-in method**, elige **Correo electrónico/contraseña**.
3. Actívalo (el primer interruptor) y clic en **Guardar**.
4. Ve a la pestaña **Users** → botón **Agregar usuario** y crea las **dos cuentas**:
   - Correo y contraseña para **ti**.
   - Correo y contraseña para **Keyla**.
5. Anota el **User UID** de cada uno (la columna de la derecha, una cadena larga de letras y
   números). Los necesitas en el Paso 5.

---

## Paso 4 — Crear la base de datos (Firestore)

1. En el menú izquierdo: **Compilación → Firestore Database** → **Crear base de datos**.
2. Elige el modo **Producción** (Production mode) y clic en Siguiente.
3. Elige la ubicación más cercana (por ejemplo `southamerica-east1`) y clic en **Habilitar**.

---

## Paso 5 — Reglas de seguridad (¡importante!)

Esto es lo que impide que un extraño lea o modifique la información de su matrimonio.

1. Dentro de **Firestore Database**, abre la pestaña **Reglas** (Rules).
2. Borra lo que haya y pega esto, **reemplazando** los dos UID por los que anotaste en el Paso 3:

   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /matrimonio/datos {
         allow read, write: if request.auth != null
           && request.auth.uid in ["UID_DE_CRISTIAN", "UID_DE_KEYLA"];
       }
     }
   }
   ```

3. Clic en **Publicar** (Publish).

> Con esto, **solo esas dos cuentas** pueden leer y escribir los datos. Nadie más, aunque
> tenga el link de la página.

---

## Paso 6 — Pegar la configuración en la página

1. Abre el archivo **`index.html`** con un editor de texto (por ejemplo, el Bloc de notas o VS Code).
2. Busca el bloque que dice:

   ```js
   const firebaseConfig = {
     apiKey: "PEGA_AQUI_TU_API_KEY",
     ...
   };
   ```

3. **Reemplaza todo ese objeto** por el que copiaste en el Paso 2. Guarda el archivo.

¡Listo! Al abrir la página aparecerá la pantalla de login. Ingresa con uno de los correos
que creaste y verás los datos. Cualquier cambio que hagas se guardará en la nube y aparecerá
en el otro dispositivo automáticamente.

---

## Cómo funciona ahora (resumen)

- Los datos viven en la nube (Firestore). Todos los dispositivos ven **lo mismo** y se
  actualiza solo, casi al instante.
- El navegador también guarda una **copia local**, así que si te quedas sin internet, sigues
  viendo la última versión (y se sincroniza al volver la conexión).
- El login es **real**: solo las cuentas que creaste pueden entrar.
- Una vez que inicias sesión, el navegador te mantiene conectado (no pide la clave cada vez).

## Preguntas frecuentes

**¿Cuánto cuesta?** $0. El plan gratuito de Firebase (Spark) cubre de sobra el uso de un
matrimonio.

**¿Y si dos editamos al mismo tiempo?** Como son solo ustedes dos, casi nunca pasará. Si
ambos editan el mismo campo en el mismo segundo, gana el último cambio guardado. Para evitarlo,
basta con avisarse si van a trabajar en la lista al mismo tiempo.

**¿Cómo cambio una contraseña?** En la consola de Firebase → Authentication → Users → los tres
puntitos junto al usuario → "Restablecer contraseña".

**¿Cómo agrego a otra persona más adelante?** Crea su usuario en Authentication (Paso 3) y
añade su UID a la lista de las reglas (Paso 5).

**¿Y el respaldo en `.json`?** El botón "⬇ Exportar" sigue funcionando y es una buena idea
descargar un respaldo de vez en cuando por seguridad.
