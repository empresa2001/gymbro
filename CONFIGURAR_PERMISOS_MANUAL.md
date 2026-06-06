# Configuración Manual de Permisos en Directus

Directus v10+ requiere configurar permisos desde la interfaz de usuario. Sigue estos pasos:

## 1. Accede a Directus Admin
- URL: http://localhost:8055
- Email: admin@gymbro.com
- Password: Admin123!

## 2. Ir a Settings → Access Control

En el menú izquierdo, haz clic en el ícono de engranaje (⚙️) → Access Control

## 3. Configurar Rol "Cliente"

1. Haz clic en el rol **"Cliente"**
2. En la sección de permisos para cada colección, configura:

| Colección | Read | Create | Update | Delete |
|-----------|------|--------|--------|--------|
| clientes | ✅ All | ❌ | ✅ All | ❌ |
| sesiones_registro | ✅ All | ✅ All | ✅ All | ❌ |
| suscripciones | ✅ All | ❌ | ❌ | ❌ |
| planes | ✅ All | ❌ | ❌ | ❌ |
| entrenadores | ✅ All | ❌ | ❌ | ❌ |
| metricas_cliente | ✅ All | ✅ All | ❌ | ❌ |

Para cada permiso, haz clic en el checkbox correspondiente.

## 4. Configurar Rol "Entrenador"

1. Haz clic en el rol **"Entrenador"**
2. Configura los permisos:

| Colección | Read | Create | Update | Delete |
|-----------|------|--------|--------|--------|
| entrenadores | ✅ All | ❌ | ✅ All | ❌ |
| clientes | ✅ All | ✅ All | ✅ All | ❌ |
| sesiones_registro | ✅ All | ❌ | ❌ | ❌ |
| suscripciones | ✅ All | ✅ All | ✅ All | ❌ |
| planes | ✅ All | ❌ | ❌ | ❌ |
| metricas_cliente | ✅ All | ✅ All | ✅ All | ❌ |

## 5. Probar

1. Cierra sesión en la app (http://localhost:5173)
2. Abre consola (F12) y ejecuta: `localStorage.clear()`
3. Refresca con Ctrl+F5
4. Logueate con:
   - Cliente: `cliente@test.com` / `Test123!`
   - Entrenador: `entrenador@test.com` / `Test123!`

---

Si tienes problemas, contáctame para ayudarte.
