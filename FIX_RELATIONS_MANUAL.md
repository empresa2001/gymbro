# Guía Manual - Arreglar Relaciones en Directus

## El problema es que los campos user_id y entrenador_asignado en la colección "clientes" no tienen las relaciones configuradas correctamente.

La solución más rápida es hacerlo manualmente desde Directus:

### Pasos:

1. **Accede a Directus:**
   - http://localhost:8055
   - Login: admin@gymbro.com / Admin123!

2. **Ve a Settings → Data Model → clientes**

3. **Arreglar campo user_id:**
   - Click en el campo "user_id"
   - En la sección "Interface", selecciona "Select Dropdown (Many to One)"
   - En "Related Collection", selecciona "Directus Users"
   - Click en el checkbox √ para guardar

4. **Arreglar campo entrenador_asignado:**
   - Click en el campo "entrenador_asignado"
   - En la sección "Interface", selecciona "Select Dropdown (Many to One)"
   - En "Related Collection", selecciona "entrenadores"
   - Click en el checkbox √ para guardar

5. **Verificar:**
   - Ve a Content → Clientes → Create Item
   - Los campos "User ID" y "Entrenador Asignado" deben mostrar dropdowns con opciones

---

## Alternativamente: Recrear la colección desde cero

Si los pasos anteriores no funcionan, la mejor opción es recrear la colección:

1. **Exportar datos (si tienes):**
   - Content → Clientes → Selecciona todos → Export

2. **Eliminar la colección:**
   - Settings → Data Model → clientes → ⋮ (menú) → Delete Collection

3. **Ejecutar el script de creación nuevamente:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File create-collections.ps1
   ```

4. **Luego ejecutar el script de permisos:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File configure-roles.ps1
   ```

---

Por favor intenta la opción manual primero (pasos 1-5). Avísame si necesitas ayuda o si continúa dando error.
