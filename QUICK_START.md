# 🚀 GYM BRO - Guía de Inicio Rápido

## ✅ Paso 1: Levantar el Backend con Docker

```bash
# Desde la raíz del proyecto (gym/)
docker-compose up -d
```

Esto iniciará:
- PostgreSQL en `localhost:5432`
- Directus en `http://localhost:8055`

**Verifica que los servicios estén corriendo:**
```bash
docker-compose ps
```

## ✅ Paso 2: Configurar Directus

1. **Accede al panel de Directus:**
   - URL: http://localhost:8055
   - Email: `admin@gymbro.com`
   - Password: `Admin123!`

2. **Importa el schema (OPCIÓN RECOMENDADA):**
   - Ve a Settings → Data Model
   - Click en el menú (⋮) → "Import Schema"
   - Selecciona el archivo `directus-schema.json`
   - Confirma la importación

   **O crea las colecciones manualmente:**
   - Sigue la guía paso a paso en `DIRECTUS_SETUP.md`

3. **Configura los Roles y Permisos:**
   - Ve a Settings → Access Control → Roles
   - Crea los roles: `Entrenador` y `Cliente`
   - Configura los permisos según `DIRECTUS_SETUP.md`

4. **Crea usuarios de prueba:**

   **Entrenador de prueba:**
   - Email: `entrenador@test.com`
   - Password: `Test123!`
   - Rol: `Entrenador`
   - No olvides crear su registro en la colección `entrenadores`

   **Cliente de prueba:**
   - Email: `cliente@test.com`
   - Password: `Test123!`
   - Rol: `Cliente`
   - Crea su registro en `clientes` y asigna un entrenador

## ✅ Paso 3: Instalar Dependencias del Frontend

```bash
cd frontend
npm install
```

Si no existe el archivo `.env`, créalo:
```bash
copy .env.example .env
```

El contenido debe ser:
```
VITE_DIRECTUS_URL=http://localhost:8055
```

## ✅ Paso 4: Iniciar el Frontend

```bash
npm run dev
```

La aplicación estará disponible en: **http://localhost:5173**

## 🔐 Credenciales de Acceso

### Superadmin
- Email: `admin@gymbro.com`
- Password: `Admin123!`

### Entrenador (después de crear)
- Email: `entrenador@test.com`
- Password: `Test123!`

### Cliente (después de crear)
- Email: `cliente@test.com`
- Password: `Test123!`

## 🎯 Prueba las Funcionalidades

### Como Admin:
1. Inicia sesión en http://localhost:5173
2. Ve estadísticas del sistema
3. Gestiona entrenadores (habilitar/deshabilitar)
4. CRUD de planes de entrenamiento

### Como Entrenador:
1. Inicia sesión
2. Ve tu dashboard
3. Crea nuevos clientes
4. Asigna planes a clientes
5. Supervisa el progreso

### Como Cliente:
1. Inicia sesión
2. Ve tu streak y estadísticas
3. Registra sesiones de entrenamiento
4. Visualiza tu progreso en gráficos
5. Revisa tu plan activo

## 🛑 Detener los Servicios

```bash
# Detener Docker
docker-compose down

# Para eliminar también los volúmenes (BORRA DATOS)
docker-compose down -v
```

## 🐛 Solución de Problemas

### Error: "Cannot connect to Directus"
- Verifica que Docker esté corriendo: `docker-compose ps`
- Revisa logs: `docker-compose logs directus`
- Asegúrate que Directus esté en puerto 8055

### Error: "Access denied"
- Verifica que los permisos estén configurados correctamente
- Revisa que el usuario tenga el rol correcto
- Confirma que existe el registro en `entrenadores` o `clientes`

### El frontend no carga estilos
- Ejecuta: `npm install`
- Reinicia el servidor: `npm run dev`

### Problemas con CORS
- Verifica que `CORS_ENABLED=true` en `.env` de Docker
- Asegúrate que `PUBLIC_URL` esté correctamente configurado

## 📚 Próximos Pasos

1. **Despliega en producción:**
   - Backend: VPS, Render, Railway, DigitalOcean
   - Frontend: Vercel, Netlify
   - Database: PostgreSQL administrado

2. **Instala como PWA:**
   - Construye: `npm run build`
   - Vista previa: `npm run preview`
   - Abre en móvil y selecciona "Instalar aplicación"

3. **Personaliza:**
   - Modifica colores en `tailwind.config.js`
   - Actualiza el nombre en `vite.config.js`
   - Añade más funcionalidades según necesites

---

**¿Necesitas ayuda?** Consulta `DIRECTUS_SETUP.md` para más detalles sobre la configuración.

🏋️ **¡Disfruta de GYM BRO MVP!** 💪
