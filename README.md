# Gestor de Inventario Hogar/Lab

Aplicación **C++/Qt** para administrar componentes electrónicos. Registro, búsqueda, alertas stock bajo, reportes CSV. Funciona en PC y **Raspberry Pi**.

**Entregas-ALSE/proyecto_2026**

## ✨ Características
- Gestión completa de inventario
- Búsqueda y filtros rápidos
- Alertas stock mínimo
- Exporta CSV
- SQLite portable
- Multiplataforma

## 🚀 Instalación
**AppImage (Linux/RPi):**
```bash
chmod +x GestorInventario.AppImage
./GestorInventario.AppImage
```

**Compilar:**
```bash
qmake && make
```

## 💻 Uso Rápido
1. Agregar componentes (+)
2. Buscar/filtrar
3. Exportar CSV
4. Configurar alertas

## 📋 Campos
| Campo | Ejemplo |
|-------|---------|
| ID | COMP001 |
| Nombre | Resistencia 10k |
| Stock | 245 |
| Mínimo | 10 |
| Ubicación | R1-C2 |

## 📄 Licencia
**MIT License** - Ver [LICENSE](LICENSE)

**Hecho con Qt6 + SQLite • Para makers y labs**
