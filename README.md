# Legacy Users - CI/CD & IaC Architecture

## Arquitectura Implementada

Se diseñó e implementó un flujo de despliegue automatizado para el monolito `legacy-users` empleando prácticas GitOps, estructurado en tres componentes técnicos:

1. **Integración Continua (CI):** Pipeline configurado en `.github/workflows/ci.yml`. Se ejecuta ante eventos `push` o `pull_request` en la rama `develop`. Despliega un entorno Ubuntu, instala Node.js 20, resuelve dependencias y ejecuta pruebas unitarias (`npm run test`). Un fallo en las pruebas aborta el pipeline; un éxito genera un artefacto del código.
2. **Infraestructura como Código (IaC):** Código modularizado con Terraform (`>= 1.6`). 
   - **Backend remoto:** Estado almacenado en un bucket S3 pre-existente.
   - **Módulo Network:** Provisión de un Security Group en AWS limitando el ingreso a la IP pública local (`/32`) en el puerto 8000 y 22.
   - **Módulo Compute:** Provisión de una instancia EC2 (Amazon Linux 2023). Se automatiza el arranque de la API inyectando un script `user_data` que emplea `yum` para la instalación de paquetes.
3. **Despliegue Continuo (CD):** Pipeline configurado en `.github/workflows/cd.yml`. Se dispara con un `merge` o `push` a la rama `main`. Autentica contra el AWS Learner Lab inyectando secretos (incluyendo `AWS_SESSION_TOKEN`), inicializa el backend S3 y aplica los cambios de infraestructura automáticamente (`terraform apply -auto-approve`).

## URL de Validación

El módulo de Autenticación de Usuarios está respondiendo en vivo en el puerto asignado (8000).

- **Endpoint:** `http://32.195.44.117:8000`