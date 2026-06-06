# 🔐 Guía Rápida: Configurar Permisos para Planes IA

Esta guía te ayudará a configurar los permisos necesarios en Directus para que los clientes puedan usar la funcionalidad de planes IA.

## 📍 Acceso a Directus Admin

1. Abre tu navegador y ve a: **http://localhost:8055**
2. Inicia sesión con tus credenciales de administrador
   - Email: (tu email de admin)
   - Password: (tu password)

---

## ⚙️ Configurar Permisos para el Rol "Cliente"

### 1. Navega a Configuración de Roles

1. En el menú lateral izquierdo, haz clic en **Settings** (⚙️)
2. Click en **Access Control** → **Roles**
3. Busca y haz clic en el rol **"Cliente"**

### 2. Configurar Permisos para `planes_ia`

Busca la colección `planes_ia` en la lista y configura los siguientes permisos:

#### ✅ CREATE (Crear)
- **Permiso**: Activado
- **Item Permissions**: Custom
- **Filter**:
  ```json
  {
    "cliente_id": {
      "_eq": "$CURRENT_USER.clientes[0].id"
    }
  }
  ```
- **Fields**: Todos excepto `id`, `date_created`, `date_updated`, `prompt_usado` (readonly)

#### ✅ READ (Leer)
- **Permiso**: Activado
- **Item Permissions**: Custom
- **Filter**:
  ```json
  {
    "cliente_id": {
      "_eq": "$CURRENT_USER.clientes[0].id"
    }
  }
  ```
- **Fields**: Todos

#### ✅ UPDATE (Actualizar)
- **Permiso**: Activado
- **Item Permissions**: Custom
- **Filter**:
  ```json
  {
    "cliente_id": {
      "_eq": "$CURRENT_USER.clientes[0].id"
    }
  }
  ```
- **Fields**: `nombre`, `descripcion`, `objetivo`, `nivel_experiencia`, `duracion_tipo`, `dias_semana`, `equipamiento`, `limitaciones`, `activo`

#### ❌ DELETE (Eliminar)
- **Permiso**: Desactivado

---

### 3. Configurar Permisos para `ejercicios_plan_ia`

Busca la colección `ejercicios_plan_ia` y configura:

#### ❌ CREATE / UPDATE / DELETE
- Todos desactivados (los ejercicios se crean automáticamente vía API)

#### ✅ READ (Leer)
- **Permiso**: Activado
- **Item Permissions**: Custom
- **Filter**:
  ```json
  {
    "plan_ia_id": {
      "cliente_id": {
        "_eq": "$CURRENT_USER.clientes[0].id"
      }
    }
  }
  ```
- **Fields**: Todos

---

### 4. Actualizar Permisos en `clientes`

Busca la colección `clientes` y verifica los permisos de UPDATE:

#### ✅ UPDATE
- Asegúrate de que el campo `tipo_plan_preferido` esté permitido para actualización
- En la sección de Fields Permissions del UPDATE, marca el checkbox para `tipo_plan_preferido`

---

## ✅ Verificación

Para verificar que todo está configurado correctamente:

1. **Verifica las colecciones en el menú Content**:
   - Deberías ver `planes_ia` con ícono 🧠
   - Deberías ver `ejercicios_plan_ia` con ícono 🏋️

2. **Prueba rápida** (opcional):
   - Como administrador, intenta crear manualmente un registro en `planes_ia`
   - Verifica que los campos se muestran correctamente

---

## 🎯 Resumen de Permisos

| Colección | CREATE | READ | UPDATE | DELETE |
|-----------|--------|------|--------|--------|
| `planes_ia` | ✅ (solo propios) | ✅ (solo propios) | ✅ (solo propios) | ❌ |
| `ejercicios_plan_ia` | ❌ | ✅ (de sus planes) | ❌ | ❌ |
| `clientes` | - | - | ✅ (+ tipo_plan_preferido) | - |

---

## 🐛 Troubleshooting

**Problema**: No veo las colecciones en Content
- **Solución**: Refresca la página de Directus (F5)

**Problema**: Error al crear un plan desde la app
- **Solución**: Verifica que los permisos de CREATE tengan el filtro correcto
- **Solución**: Verifica que todos los campos necesarios estén permitidos

**Problema**: No puedo leer los ejercicios del plan
- **Solución**: Verifica el filtro de READ en `ejercicios_plan_ia`
- **Solución**: Debe incluir la relación `plan_ia_id.cliente_id`

---

## ⏭️ Siguiente Paso

Una vez configurados los permisos, puedes:
1. Actualizar los componentes frontend (`ClienteDashboard`, `MyPlanPage`)
2. Probar el flujo completo de generación de planes
