# Configuración de Roles y Permisos - Multi-Tenancy

Guía completa para configurar los roles y permisos en Directus para la arquitectura multi-tenant.

---

## 📋 Resumen de Roles

| Rol | Descripción | Acceso |
|-----|-------------|--------|
| **Super Admin** | Ustedes (plataforma) | TODO - todos los gimnasios |
| **Gimnasio** | Dueño/Admin del gimnasio | Solo SU gimnasio y sus recursos |
| **Entrenador** | Entrenador del gimnasio | Solo SUS clientes |
| **Cliente** | Usuario final | Solo SU información |

---

## 🎯 Paso 1: Crear Rol "Gimnasio"

### Opción A: Crear Nuevo Rol

1. Ir a **Settings → Roles & Permissions**
2. Click en **"Create Role"** (botón +)
3. Configurar:
   - **Name**: `Gimnasio`
   - **Description**: `Administrador de un gimnasio individual`
   - **Icon**: `fitness_center`
   - **Admin Access**: ❌ NO (desactivado)
   - **App Access**: ✅ YES (activado)

4. Click **Save**
5. **COPIAR EL UUID** del rol creado (lo necesitarás para el frontend)

### Opción B: Renombrar "Administrator" Existente

Si prefieres renombrar el rol existente:
1. Ir a **Settings → Roles & Permissions**
2. Click en rol **"Administrator"**
3. Cambiar nombre a **"Gimnasio"**
4. Guardar

> [!WARNING]
> Si renombras "Administrator", necesitarás crear un nuevo rol "Super Admin" para ustedes.

---

## 🎯 Paso 2: Crear Rol "Super Admin" (Opcional)

Si renombraste "Administrator" o quieres un rol separado para ustedes:

1. **Settings → Roles & Permissions**
2. **Create Role**
3. Configurar:
   - **Name**: `Super Admin`
   - **Description**: `Administrador de la plataforma - acceso total`
   - **Icon**: `shield`
   - **Admin Access**: ✅ YES (FULL ACCESS)
   - **App Access**: ✅ YES

4. Guardar y copiar UUID

---

## 🔐 Paso 3: Configurar Permisos por Rol

### A. Rol: SUPER ADMIN

**Acceso Total** ✅

Si activaste "Admin Access", ya tiene todo. Si no:

#### Permisos de Collections:

| Collection | Create | Read | Update | Delete |
|------------|--------|------|--------|--------|
| gimnasios | ✅ All | ✅ All | ✅ All | ✅ All |
| entrenadores | ✅ All | ✅ All | ✅ All | ✅ All |
| clientes | ✅ All | ✅ All | ✅ All | ✅ All |
| planes | ✅ All | ✅ All | ✅ All | ✅ All |
| ejercicios | ✅ All | ✅ All | ✅ All | ✅ All |
| suscripciones | ✅ All | ✅ All | ✅ All | ✅ All |
| directus_users | ✅ All | ✅ All | ✅ All | ✅ All |
| directus_files | ✅ All | ✅ All | ✅ All | ✅ All |

**Sin filtros** - acceso completo a todo.

---

### B. Rol: GIMNASIO

Este rol puede gestionar SU gimnasio y SUS recursos.

#### 1. Collection: `gimnasios`

**CREATE**: ❌ NO
- Los gimnasios los crea Super Admin

**READ**: ✅ YES
- **Filter Rule**:
  ```json
  {
    "user_id": {
      "_eq": "$CURRENT_USER"
    }
  }
  ```

**UPDATE**: ✅ YES
- **Filter Rule**:
  ```json
  {
    "user_id": {
      "_eq": "$CURRENT_USER"
    }
  }
  ```
- **Field Permissions**:
  - ✅ nombre, descripcion, direccion, telefono, logo, configuracion
  - ❌ user_id, id, fecha_registro (read-only)

**DELETE**: ❌ NO

---

#### 2. Collection: `entrenadores`

**CREATE**: ✅ YES
- **Preset Values**:
  ```json
  {
    "gimnasio_id": "$CURRENT_USER.gimnasio.id"
  }
  ```

**READ**: ✅ YES
- **Filter Rule**:
  ```json
  {
    "gimnasio_id": {
      "_eq": "$CURRENT_USER.gimnasio.id"
    }
  }
  ```

**UPDATE**: ✅ YES
- **Filter Rule**:
  ```json
  {
    "gimnasio_id": {
      "_eq": "$CURRENT_USER.gimnasio.id"
    }
  }
  ```

**DELETE**: ✅ YES
- **Filter Rule**:
  ```json
  {
    "gimnasio_id": {
      "_eq": "$CURRENT_USER.gimnasio.id"
    }
  }
  ```

---

#### 3. Collection: `clientes`

**CREATE**: ✅ YES (puede crear clientes para sus entrenadores)

**READ**: ✅ YES
- **Filter Rule** (clientes de sus entrenadores):
  ```json
  {
    "entrenador_asignado": {
      "gimnasio_id": {
        "_eq": "$CURRENT_USER.gimnasio.id"
      }
    }
  }
  ```

**UPDATE**: ✅ YES
- **Same filter as READ**

**DELETE**: ✅ YES
- **Same filter as READ**

---

#### 4. Collection: `planes`

**CREATE**: ✅ YES

**READ**: ✅ YES
- **Filter Rule** (planes de sus entrenadores):
  ```json
  {
    "_or": [
      {
        "creador_id": {
          "gimnasio_id": {
            "_eq": "$CURRENT_USER.gimnasio.id"
          }
        }
      },
      {
        "tipo": {
          "_eq": "ia"
        }
      }
    ]
  }
  ```

**UPDATE**: ✅ YES (same filter)

**DELETE**: ✅ YES (same filter)

---

#### 5. Collection: `ejercicios`

**CREATE**: ✅ YES

**READ**: ✅ ALL (biblioteca compartida)

**UPDATE**: ✅ Solo los que creó el gimnasio
- **Filter Rule**:
  ```json
  {
    "creado_por": {
      "gimnasio_id": {
        "_eq": "$CURRENT_USER.gimnasio.id"
      }
    }
  }
  ```

**DELETE**: ✅ YES (same filter)

---

#### 6. Collection: `suscripciones`

**CREATE**: ✅ YES

**READ**: ✅ YES
- **Filter Rule**:
  ```json
  {
    "cliente_id": {
      "entrenador_asignado": {
        "gimnasio_id": {
          "_eq": "$CURRENT_USER.gimnasio.id"
        }
      }
    }
  }
  ```

**UPDATE**: ✅ YES (same filter)

**DELETE**: ✅ YES (same filter)

---

#### 7. Collection: `directus_users`

**CREATE**: ✅ YES (para crear usuarios de entrenadores y clientes)
- **Preset Values**:
  ```json
  {
    "role": "<ENTRENADOR_ROLE_ID o CLIENTE_ROLE_ID>"
  }
  ```

**READ**: ✅ Limited
- **Filter Rule**:
  ```json
  {
    "_or": [
      {
        "id": {
          "_eq": "$CURRENT_USER"
        }
      },
      {
        "entrenador": {
          "gimnasio_id": {
            "_eq": "$CURRENT_USER.gimnasio.id"
          }
        }
      },
      {
        "cliente": {
          "entrenador_asignado": {
            "gimnasio_id": {
              "_eq": "$CURRENT_USER.gimnasio.id"
            }
          }
        }
      }
    ]
  }
  ```

**UPDATE**: ✅ Limited (same filter)

**DELETE**: ❌ NO

---

#### 8. Collection: `directus_files`

**CREATE**: ✅ YES

**READ**: ✅ YES
- **Filter Rule**:
  ```json
  {
    "uploaded_by": {
      "_in": "$CURRENT_USER.gimnasio.users"
    }
  }
  ```

**UPDATE**: ✅ YES (same filter)

**DELETE**: ✅ YES (same filter)

---

### C. Rol: ENTRENADOR

#### 1. Collection: `gimnasios`

**READ**: ✅ Limited
- **Filter Rule** (solo su gimnasio):
  ```json
  {
    "id": {
      "_eq": "$CURRENT_USER.entrenador.gimnasio_id"
    }
  }
  ```

**CREATE/UPDATE/DELETE**: ❌ NO

---

#### 2. Collection: `entrenadores`

**READ**: ✅ YES
- **Filter Rule** (solo su perfil):
  ```json
  {
    "user_id": {
      "_eq": "$CURRENT_USER"
    }
  }
  ```

**UPDATE**: ✅ YES (solo su perfil, same filter)

**CREATE/DELETE**: ❌ NO

---

#### 3. Collection: `clientes`

**CREATE**: ✅ YES
- **Preset Values**:
  ```json
  {
    "entrenador_asignado": "$CURRENT_USER.entrenador.id"
  }
  ```

**READ**: ✅ YES
- **Filter Rule** (solo sus clientes):
  ```json
  {
    "entrenador_asignado": {
      "_eq": "$CURRENT_USER.entrenador.id"
    }
  }
  ```

**UPDATE**: ✅ YES (same filter)

**DELETE**: ✅ YES (same filter)

---

#### 4. Collection: `planes`

**CREATE**: ✅ YES

**READ**: ✅ YES
- **Filter Rule**:
  ```json
  {
    "_or": [
      {
        "creador_id": {
          "_eq": "$CURRENT_USER.entrenador.id"
        }
      },
      {
        "tipo": {
          "_eq": "ia"
        }
      }
    ]
  }
  ```

**UPDATE/DELETE**: ✅ Only own plans
- **Filter Rule**:
  ```json
  {
    "creador_id": {
      "_eq": "$CURRENT_USER.entrenador.id"
    }
  }
  ```

---

#### 5. Collection: `ejercicios`

**CREATE**: ✅ YES

**READ**: ✅ ALL (biblioteca compartida)

**UPDATE/DELETE**: ✅ Only own exercises
- **Filter Rule**:
  ```json
  {
    "creado_por": {
      "_eq": "$CURRENT_USER.entrenador.id"
    }
  }
  ```

---

#### 6. Collection: `suscripciones`

**CREATE**: ✅ YES

**READ**: ✅ YES
- **Filter Rule** (suscripciones de sus clientes):
  ```json
  {
    "cliente_id": {
      "entrenador_asignado": {
        "_eq": "$CURRENT_USER.entrenador.id"
      }
    }
  }
  ```

**UPDATE/DELETE**: ✅ YES (same filter)

---

#### 7. Collection: `directus_users`

**CREATE**: ✅ LIMITED (solo clientes)
- **Preset Values**:
  ```json
  {
    "role": "<CLIENTE_ROLE_ID>"
  }
  ```

**READ**: ✅ LIMITED
- **Filter Rule**:
  ```json
  {
    "_or": [
      {
        "id": {
          "_eq": "$CURRENT_USER"
        }
      },
      {
        "cliente": {
          "entrenador_asignado": {
            "_eq": "$CURRENT_USER.entrenador.id"
          }
        }
      }
    ]
  }
  ```

**UPDATE**: ✅ LIMITED (same filter)

**DELETE**: ❌ NO

---

#### 8. Collection: `directus_files`

**CREATE**: ✅ YES

**READ**: ✅ YES
- **Filter Rule**:
  ```json
  {
    "_or": [
      {
        "uploaded_by": {
          "_eq": "$CURRENT_USER"
        }
      },
      {
        "uploaded_by": {
          "cliente": {
            "entrenador_asignado": {
              "_eq": "$CURRENT_USER.entrenador.id"
            }
          }
        }
      }
    ]
  }
  ```

**UPDATE/DELETE**: ✅ Only own files

---

### D. Rol: CLIENTE

#### 1. Collection: `gimnasios`

**READ**: ✅ LIMITED
- **Filter Rule** (solo su gimnasio a través del entrenador):
  ```json
  {
    "id": {
      "_eq": "$CURRENT_USER.cliente.entrenador_asignado.gimnasio_id"
    }
  }
  ```

**CREATE/UPDATE/DELETE**: ❌ NO

---

#### 2. Collection: `entrenadores`

**READ**: ✅ LIMITED
- **Filter Rule** (solo su entrenador):
  ```json
  {
    "id": {
      "_eq": "$CURRENT_USER.cliente.entrenador_asignado"
    }
  }
  ```

**CREATE/UPDATE/DELETE**: ❌ NO

---

#### 3. Collection: `clientes`

**READ**: ✅ LIMITED
- **Filter Rule** (solo su perfil):
  ```json
  {
    "user_id": {
      "_eq": "$CURRENT_USER"
    }
  }
  ```

**UPDATE**: ✅ LIMITED (solo su perfil, same filter)
- **Field Permissions**:
  - ✅ objetivo, fecha_nacimiento, altura_cm, peso_kg
  - ❌ entrenador_asignado, user_id (read-only)

**CREATE/DELETE**: ❌ NO

---

#### 4. Collection: `planes`

**READ**: ✅ LIMITED
- **Filter Rule** (planes asignados a él):
  ```json
  {
    "_or": [
      {
        "suscripciones": {
          "cliente_id": {
            "user_id": {
              "_eq": "$CURRENT_USER"
            }
          }
        }
      },
      {
        "tipo": {
          "_eq": "ia"
        }
      }
    ]
  }
  ```

**CREATE/UPDATE/DELETE**: ❌ NO

---

#### 5. Collection: `ejercicios`

**READ**: ✅ ALL (biblioteca compartida)

**CREATE/UPDATE/DELETE**: ❌ NO

---

#### 6. Collection: `suscripciones`

**READ**: ✅ LIMITED
- **Filter Rule**:
  ```json
  {
    "cliente_id": {
      "user_id": {
        "_eq": "$CURRENT_USER"
      }
    }
  }
  ```

**CREATE/UPDATE/DELETE**: ❌ NO

---

#### 7. Collection: `sesiones_registro`

**CREATE**: ✅ YES
- **Preset Values**:
  ```json
  {
    "cliente_id": "$CURRENT_USER.cliente.id"
  }
  ```

**READ**: ✅ LIMITED
- **Filter Rule**:
  ```json
  {
    "cliente_id": {
      "user_id": {
        "_eq": "$CURRENT_USER"
      }
    }
  }
  ```

**UPDATE/DELETE**: ✅ YES (same filter)

---

#### 8. Collection: `directus_users`

**READ**: ✅ VERY LIMITED
- **Filter Rule** (solo su propio usuario):
  ```json
  {
    "id": {
      "_eq": "$CURRENT_USER"
    }
  }
  ```

**UPDATE**: ✅ LIMITED (solo su perfil)
- **Field Permissions**:
  - ✅ first_name, last_name, avatar
  - ❌ email, role, status (read-only)

**CREATE/DELETE**: ❌ NO

---

#### 9. Collection: `directus_files`

**CREATE**: ✅ YES (solo para avatar)

**READ**: ✅ LIMITED
- **Filter Rule**:
  ```json
  {
    "uploaded_by": {
      "_eq": "$CURRENT_USER"
    }
  }
  ```

**UPDATE/DELETE**: ✅ YES (only own files)

---

## 🎯 Paso 4: Configurar Relaciones para Filtros

Para que los filtros funcionen correctamente, Directus necesita poder acceder a las relaciones. Asegúrate de que las siguientes relaciones estén configuradas:

### A. Usuarios necesitan acceder a sus perfiles

1. **Super Admin / Gimnasio**: `user.gimnasio` (one-to-one)
2. **Entrenador**: `user.entrenador` (one-to-one)
3. **Cliente**: `user.cliente` (one-to-one)

### B. Verificar en Directus Admin

1. Ir a **Settings → Data Model**
2. Click en `directus_users`
3. Verificar que existen las relaciones:
   - `gimnasio` (Many-to-One → gimnasios.user_id)
   - `entrenador` (Many-to-One → entrenadores.user_id)
   - `cliente` (Many-to-One → clientes.user_id)

---

## 📝 Paso 5: Copiar UUIDs de Roles

Después de crear/configurar los roles, necesitas copiar sus UUIDs:

1. **Settings → Roles & Permissions**
2. Click en cada rol
3. La URL mostrará el UUID:
   ```
   http://localhost:8055/admin/settings/roles/UUID-AQUI
   ```

4. Copia los UUIDs:

```javascript
const ROLE_IDS = {
    SUPER_ADMIN: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
    GIMNASIO: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
    ENTRENADOR: '4192d542-2329-4a72-bbc9-d0ba3d5b2f21', // Ya conocido
    CLIENTE: 'cdece3c6-5da4-4fed-88c1-bf379b9be80c'     // Ya conocido
};
```

---

## ✅ Checklist de Verificación

Antes de continuar al frontend, verifica:

- [ ] Rol "Gimnasio" creado
- [ ] Rol "Super Admin" creado (si aplica)
- [ ] Permisos de "Gimnasio" configurados con filtros
- [ ] Permisos de "Entrenador" verificados
- [ ] Permisos de "Cliente" verificados
- [ ] Relaciones `user.gimnasio`, `user.entrenador`, `user.cliente` existen
- [ ] UUIDs de roles copiados
- [ ] Testear login como cada rol (opcional)

---

## 🧪 Testing Sugerido

### Crear Usuarios de Prueba

1. **Usuario Gimnasio**:
   - Email: `gim1@test.com`
   - Role: Gimnasio
   - Crear registro en tabla `gimnasios` con este user_id

2. **Usuario Entrenador**:
   - Email: `trainer1@test.com`
   - Role: Entrenador
   - Crear registro en `entrenadores` con este user_id y gimnasio_id

3. **Usuario Cliente**:
   - Email: `client1@test.com`
   - Role: Cliente
   - Ya existe uno creado en la migración

### Probar Permisos

Login con cada usuario y verificar que solo ven sus datos.

---

## 🆘 Troubleshooting

### "Permission denied" al intentar leer datos

- Verificar que los filtros están correctamente escritos
- Verificar que las relaciones existen en Directus
- Verificar que el usuario tiene un registro en la tabla correspondiente (gimnasio/entrenador/cliente)

### Filtros no funcionan

- Ir a Settings → Data Model
- Verificar que las relaciones están configuradas correctamente
- Usar el panel de API Explorer para probar queries

### Usuario no puede crear recursos

- Verificar "Preset Values" están configurados
- Verificar que el rol tiene permiso CREATE en la collection

---

## 📋 Próximos Pasos

Una vez completada la configuración de roles:

1. ✅ Copiar UUIDs al código frontend
2. ✅ Actualizar `directus.js` con nuevos ROLE_IDS
3. ✅ Implementar `gimnasioService`
4. ✅ Crear componentes Super Admin UI
5. ✅ Adaptar componentes Admin → Gimnasio

