# 🧪 Guía de Testing Manual - GYM BRO MVP

## ✅ Estado del Sistema

**Backend:**
- ✅ Docker Compose corriendo
- ✅ Directus en http://localhost:8055
- ✅ PostgreSQL funcionando
- ✅ 6 colecciones creadas
- ✅ 2 roles configurados (Entrenador, Cliente)
- ✅ Permisos configurados

**Frontend:**
- ✅ React app corriendo en http://localhost:5173
- ✅ SDK de Directus actualizado a v12+
- ✅ Todas las rutas configuradas
- ✅ Componentes creados

---

## 🔐 Credenciales de Prueba

### Admin (Siempre funcionará en Directus)
```
Email: admin@gymbro.com
Password: Admin123!
```

### Entrenador
```
Email: entrenador@test.com
Password: Test123!
```

### Cliente (Puede requerir creación manual)
```
Email: cliente@test.com
Password: Test123!
```

---

## 🧪 Pasos de Testing

### 1. Verificar Backend (Directus)

**Accede a Directus:**
```
URL: http://localhost:8055
Login: admin@gymbro.com / Admin123!
```

**Verifica:**
- [ ] Se puede acceder al panel de Directus
- [ ] Las 6 colecciones existen (planes, entrenadores, clientes, suscripciones, sesiones_registro, metricas_cliente)
- [ ] Los roles "Entrenador" y "Cliente" existen
- [ ] Existe el usuario entrenador@test.com
- [ ] Existe un plan de ejemplo
- [ ] Existen 4 sesiones de entrenamiento

---

### 2. Test Login Frontend con Admin

**Pasos:**
1. Abre http://localhost:5173
2. Ingresa:
   - Email: admin@gymbro.com
   - Password: Admin123!
3. Click en "Ingresar"

**Resultado Esperado:**
- ✅ Redirección a /admin
- ✅ Dashboard de admin visible
- ✅ Estadísticas mostradas (usuarios, entrenadores, clientes)

**Si falla:**
- Abre la consola del navegador (F12)
- Busca errores en la tab "Console"
- Anota el error exacto

---

### 3. Crear Usuario Cliente Manualmente (Si es necesario)

Si el usuario cliente no existe o no puede hacer login:

**En Directus (http://localhost:8055):**

1. **Crear Usuario:**
   - Ve a "User Directory" → "Create User"
   - Email: cliente@test.com
   - Password: Test123!
   - First Name: Maria
   - Last Name: Rodriguez
   - Role: **Cliente** (importante!)
   - Status: Active
   - Click "Save"
   - **Anota el ID del usuario**

2. **Crear Registro de Cliente:**
   - Ve a Content → "clientes" → "Create Item"
   - user_id: Selecciona "Maria Rodriguez" (cliente@test.com)
   - entrenador_asignado: Selecciona el entrenador existente
   - objetivo: "Perder peso y tonificar"
   - altura_cm: 165
   - Click "Save"

---

### 4. Test Login con Cliente

**Pasos:**
1. Abre http://localhost:5173 (en ventana incógnito o después de logout)
2. Ingresa:
   - Email: cliente@test.com
   - Password: Test123!
3. Click en "Ingresar"

**Resultado Esperado:**
- ✅ Redirección a /cliente
- ✅ Dashboard de cliente visible con:
  - Contador de racha 🔥
  - Estadísticas semanales
  - Gráfico de progreso
  - Estado de suscripción
  - Últimas 5 sesiones

**Probar Funcionalidad:**
1. Click en "Sesiones" en el navbar
2. Llenar el formulario:
   - Fecha: Hoy
   - Horas: 1.5
   - Tipo: Pesas
   - Notas: "Prueba desde frontend"
3. Click "Registrar Sesión"
4. Debe mostrar modal de éxito ✨
5. Volver al dashboard → Debería verse la nueva sesión

---

### 5. Test Login con Entrenador

**Pasos:**
1. Abre http://localhost:5173 (nueva ventana incógnito o logout)
2. Ingresa:
   - Email: entrenador@test.com
   - Password: Test123!
3. Click en "Ingresar"

**Resultado Esperado:**
- ✅ Redirección a /entrenador
- ✅ Dashboard de entrenador visible con:
  - Estadísticas de clientes
  - Lista de clientes asignados

---

## 🐛 Troubleshooting

### Problema: "Credenciales incorrectas"

**Posibles causas:**

1. **SDK de Directus aún no está actualizado en el navegador**
   - Solución: Ctrl+F5 para refrescar sin caché
   - O cierra y vuelve a abrir la pestaña

2. **Error en la conexión con Directus**
   - Abre la consola (F12) → Tab "Network"
   - Intenta hacer login
   - Busca la petición a `/auth/login`
   - Si está en rojo, verifica:
     - ¿Directus está corriendo? `docker-compose ps`
     - ¿El proxy de Vite funciona? (debería redirigir `/api` a `http://localhost:8055`)

3. **Usuario no existe o contraseña incorrecta**
   - Verifica en Directus que el usuario existe
   - Resetea la contraseña desde Directus si es necesario

### Problema: "Cannot read properties of undefined"

**Causa:** El código SDK puede no estar actualizado correctamente

**Solución:**
1. Detén npm: `Ctrl+C` en la terminal donde corre `npm run dev`
2. Reinicia: `npm run dev`
3. Refresca el navegador con Ctrl+F5

### Problema: Error de CORS

**Solución:**
```bash
# Aseg úrate que Directus tiene CORS habilitado
# En el archivo .env del proyecto raíz:
CORS_ENABLED=true
CORS_ORIGIN=http://localhost:5173
```

Reinicia Docker:
```bash
docker-compose restart
```

---

## ✅ Checklist Final

- [ ] Admin puede hacer login
- [ ] Admin ve dashboard con estadísticas
- [ ] Cliente puede hacer login
- [ ] Cliente ve su dashboard
- [ ] Cliente puede registrar sesiones
- [ ] Entrenador puede hacer login
- [ ] Entrenador ve lista de clientes
- [ ] No hay errores en consola

---

## 📞 Si Necesitas Ayuda

**Información útil para debug:**
1. Captura de pantalla de la consola del navegador (F12 → Console)
2. Captura de pantalla de la tab Network (F12 → Network → failed request)
3. El error exacto que aparece

**Revisa también:**
- `docker-compose logs directus` - Logs del backend
- Consola del navegador - Errores del frontend

---

¡El sistema está 99% completo! Solo falta verificar que la autenticación funcione correctamente con los cambios del SDK. 💪
