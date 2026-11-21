# Fuente de Alimentación Multisalida para Laboratorio

**Universidad Tecnológica de Pereira (UTP)**  
**Programa:** Ingeniería Mecatrónica  
**Asignatura:** Diseño y Prototipado Electrónico  
**Autor:** Yeison Eduardo González  
**Semestre:** 2026-2  

---

## Descripción General

Este proyecto consiste en el diseño, captura esquemática jerárquica, ruteo de tarjeta de circuito impreso (PCB) en **Altium Designer** y prototipado de una **fuente de alimentación conmutada (SMPS) multisalida** orientada a pruebas y desarrollo de proyectos electrónicos en laboratorio.

El sistema recibe energía de un transformador reductor externo de **24 VAC**, realiza la rectificación de onda completa y el filtrado capacitivo para generar un bus principal de corriente continua (**VIN DC** entre ~26.35 V y 36.83 V), y regula cinco rieles independientes con referencia común (**GND**) mediante etapas de conversión DC/DC de alta eficiencia integradas en la PCB. La etapa de alta tensión (red de 120 VAC, interruptor general, portafusible primario y transformador) se mantiene aislada fuera de la tarjeta por seguridad eléctrica.

---

## Especificaciones Eléctricas

### Etapa de Entrada y Bus Principal
| Parámetro | Especificación | Notas de Diseño |
| :--- | :--- | :--- |
| **Alimentación primaria** | 120 VAC / 60 Hz | Con interruptor general (≥ 10 A) y fusible retardado T5A externos |
| **Transformador de entrada** | 24 VAC RMS / ≥ 353 VA | Corriente secundaria RMS estimada: ~12.24 A |
| **Rectificación** | Puente de diodos de onda completa | Capacidad ≥ 15 A / 1000 V (ej. KBPC1510) con disipador |
| **Filtrado capacitivo** | Banco de 4 × 4700 µF / 50 V | Capacidad total: 18,800 µF (mínimo requerido: 14,172 µF) + resistencia de descarga (2.2 kΩ / 2 W) |
| **Tensión del bus DC ($V_{IN}$)** | 26.35 V – 36.83 V | Rizado pico a pico máximo permitido en bus: 4 Vpp |
| **Potencia total de salida** | 151.9 W | Eficiencia global estimada: ~84.8 % (Potencia de entrada: ~179.2 W) |

### Rieles de Salida Regulada
| Riel de Salida | Tensión Nominal | Corriente Máx. | Corriente de Diseño (+20 %) | Potencia Máx. | Topología / Regulador |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **+12 V** | +12.0 V | 5.0 A | 6.0 A | 60.0 W | Convertidor Buck (`XL4016E1`) |
| **+5 V** | +5.0 V | 5.0 A | 6.0 A | 25.0 W | Convertidor Buck (`XL4016E1`) |
| **+3.3 V** | +3.3 V | 3.0 A | 3.6 A | 9.9 W | Convertidor Buck (`XL4016E1`) + protección TVS |
| **−12 V** | −12.0 V | 1.0 A | 1.2 A | 12.0 W | Convertidor Buck-Boost inversor (`LM2596HV-ADJ`) |
| **Salida Variable** | 1.25 V – 15.0 V | 3.0 A | 3.6 A | 45.0 W | Convertidor Buck ajustable (`LM2678T-ADJ` + potenciómetro 10 kΩ) |

### Criterios de Calidad y Manufactura
* **Rizado y regulación:** Rizado ≤ 100 mVpp y exactitud dentro de ±5 % en todos los rieles.
* **Protección:** Fusible/PTC individual por cada riel de salida, limitación térmica y de corriente integrada en los controladores, y supresor de transitorios (TVS) en el riel de +3.3 V.
* **Fabricación:** PCB diseñada para manufactura por termotransferencia (cobre de 1 oz, pistas de potencia dimensionadas según norma IPC-2221 con ancho mínimo de 0.5 mm y encapsulados through-hole / SMD de paso amplio).

---

## Estructura del Repositorio

```text
├── Documentacion/                                  # Documentación técnica y diagramas del proyecto
│   └── 000_Hierarchical.png                        # esquematico
│   ├── Documentacion_Fuente_Multisalida.xlsx       # Requerimientos, restricciones, BOM y cálculos IPC-2221
│   ├── HBLD_Fuente_Multisalida.drawio              # Archivo editable del diagrama de bloques de alto nivel
│   └── HBLD_fuente_multisalida.png                 # Diagrama de bloques de alto nivel (High-Level Block Diagram)
│   └── pcb_3d.png                                  # Imagen de la placa en 3d

├── PCB/
│   └── Trunk/                                      # Proyecto principal de Altium Designer
│       ├── Project Logs for Project power s.../    # Registros y reportes de compilación/ERC/DRC
│       ├── 000_Hierarchical.SchDoc                 # Hoja esquemática maestra (jerarquía del sistema)
│       ├── 100_AC-DC.SchDoc                        # Etapa de entrada AC, rectificación y filtrado capacitivo
│       ├── 200_DC-DC.SchDoc                        # Etapas de regulación DC/DC (rieles principales)
│       ├── 300_DC-DC.SchDoc                        # Etapas de regulación DC/DC adicionales
│       ├── 400_DC-DC.SchDoc                        # Etapa de conversión inversora / salida auxiliar
│       ├── Main_PCB_V1R0_XXXXXX.PcbDoc             # Diseño de circuito impreso (layout y ruteo)
│       ├── Power_Supply_MainBoard.OutJob           # Archivo de generación de salidas (Gerber, Drill, PDF, BOM)
│       ├── Project power supply.PrjPCB             # Archivo maestro del proyecto en Altium Designer
│       ├── Project power supply.PrjPCBStructure    # Estructura jerárquica del proyecto
│       └── trunk.txt                               # Control / notas de versión del trunk
├── Templates/                                      # Plantillas de hojas esquemáticas y documentación
├── .gitignore                                      # Archivos temporales de Altium ignorados por Git
└── README.md                                       # Documentación principal del repositorio