# Pasos pendientes (trabajo manual)

Este archivo resume lo que queda por hacer de tu parte para cerrar la tarea.
El repositorio ya contiene la IaC de demostración, el pipeline, la política
propia y el informe; lo que falta requiere tu cuenta de GitHub (protección de
rama, PRs, capturas) y la entrega en la plataforma del curso.

Repo: <https://github.com/Pablokill2004/Ciberseguridad-Analisis_IaC>

> Recuerda: `Tarea_Analisis_de_seguridad_IaC_en_el_pipeline.md` está en
> `.gitignore` y **no** debe subirse.

---

## 1. Publicar la línea base en `main`

El commit local ya está preparado. Publícalo:

```powershell
git push origin main
```

Verifica en GitHub que se lanzó el workflow **Seguridad IaC**. En esta primera
ejecución el job **debe fallar** (la IaC de línea base es insegura a propósito):
eso es la evidencia de la línea base y de que el gate funciona.

---

## 2. Proteger la rama `main`

1. Ve a **Settings → Rules → Rulesets → New branch ruleset**.
2. Nombre: `proteccion-main`.
3. *Target branches* → **Add target → Include by pattern** → `main`.
4. Activa **Require a pull request before merging** (1 aprobación es opcional).
5. Activa **Require status checks to pass** y añade el check **`Escaneo IaC`**
   (es el nombre del job del workflow; aparece en la lista tras la primera
   ejecución).
6. Activa **Block force pushes**.
7. **Create**.

> Alternativa clásica: **Settings → Branches → Add branch protection rule**.

Captura de pantalla del ruleset: va al informe en la sección *Evidencia del
gate*.

---

## 3. PR #1 — demostrar que el gate bloquea

La rama ya está preparada localmente y cambia el SSH del Security Group a
`0.0.0.0/0` (hallazgo `CKV_AWS_24`).

```powershell
git push origin gate/prueba-bloqueo
```

1. Abre el PR hacia `main` con el título
   **"Prueba de gate: SSH abierto a 0.0.0.0/0"**.
2. Espera a que termine **Escaneo IaC**: debe quedar en rojo y el log debe
   mostrar `CKV_AWS_24`.
3. Captura:
   - el PR con el check en rojo y el log del gate;
   - el recuadro de merge bloqueado (*Merging is blocked* / *Required status
     check*).
4. **Cierra el PR sin fusionar** (no lo mergees).
5. Copia el enlace del PR en `docs/informe.md` donde dice `[RELLENA: enlace PR #1]`.

---

## 4. PR #2 — remediación y excepción

La rama ya está preparada localmente con un commit por tipo de corrección y la
excepción documentada.

```powershell
git push origin remediacion/hallazgos-checkov
```

1. Abre el PR hacia `main` con el título
   **"Remediación: hallazgos Checkov/ansible-lint y excepción documentada"**.
2. Verifica que **Escaneo IaC** quede en **verde** (los tres gates pasan).
3. Fusiona el PR (merge commit o squash).
4. Captura el PR en verde y el merge; copia el enlace en
   `docs/informe.md` donde dice `[RELLENA: enlace PR #2]`.

---

## 5. Evidencia SARIF

1. Ve a **Security → Code scanning**.
2. Debe aparecer la herramienta **Checkov** (categoría `checkov`) con los
   hallazgos de la ejecución de la línea base.
3. Captura la lista de hallazgos.
4. Si quieres respaldo descargable: **Actions → run de la línea base →
   Artifacts** (el workflow sube `reportes/results_sarif.sarif` vía Code
   Scanning; si prefieres artifact, está explicado en el informe).

---

## 6. Completar el informe

En `docs/informe.md`, busca los marcadores `[RELLENA` y escribe:

- enlace del PR #1 y del PR #2;
- nombres de los integrantes y del aprobador de la excepción;
- enlaces/rutas de las capturas que subas (por ejemplo `docs/evidencias/pr1-bloqueado.png`).

Después exporta a PDF (requisito de la entrega):

- Opción A (VS Code): extensión **Markdown PDF** → *Export (pdf)*.
- Opción B (pandoc): `pandoc docs/informe.md -o docs/informe.pdf --pdf-engine=xelatex`
  (o `-o docs/informe.pdf` usando el motor que tengas instalado).
- Opción C: abrir el `.md` renderizado en el navegador → *Imprimir → Guardar como PDF*.

Guarda el PDF en `docs/informe.pdf` y haz commit:

```powershell
git add docs/informe.pdf docs/informe.md docs/evidencias
git commit -m "docs: evidencias y PDF del informe"
git push origin main
```

---

## 7. Commits de ambos integrantes

La rúbrica exige commits de los dos integrantes. Pídele a tu compañero/a que
haga al menos un commit real desde su cuenta, por ejemplo uno de los arreglos
del PR #2 o una edición del informe. Lo más simple:

1. Tu compañero/a clona el repo o se agrega como colaborador.
2. Hace un cambio pequeño en su rama (por ejemplo, mejora una sección del
   informe o un comentario del playbook).
3. Commit y push; ese commit aparecerá en la historia de `main` tras el merge.

---

## 8. Declaración de uso de IA

La sección *Conclusiones → Uso de IA* del informe ya tiene el texto; revísalo y
ajústalo si usaste la IA para algo adicional.

---

## 9. Entrega

Sube a la plataforma del curso:

- el enlace al repositorio: `https://github.com/Pablokill2004/Ciberseguridad-Analisis_IaC`
- el PDF: `docs/informe.pdf`
