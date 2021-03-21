# Estados entrelazados en Qiskit, Yao y Q Sharp
Repositorio con los cuadernos utilizados en el stream "Estados entrelazados en Qiskit, Yao y Q Sharp", el cual puede encontrarse en: https://youtu.be/CAdtzmu1Aiw 

Respectivamente presentados por:
- **Qiskit**: Victor Onofre
- **Yao**: Luis Felipe Flores
- **Q#**: Alberto Romo

# ¿Cómo ejecutar los archivos dentro de este repositorio?

A continuación instrucciones generales de cómo ejecutar cada uno de los cuadernos:

- **Qiskit**: Tener una instalación de Python con Qiskit instalado, y librerías generales (numpy, etc.) utiilizadas en el cuaderno de Qiskit.
- **Yao**: Tener Julia +1.5 instalado, posterior a ello, ejecutar: `using Pkg; Pkg.activate("."); Pkg.instantiate()` para poder instalar todas las dependencias especificadas en los archivos `.toml`
- **Q#**: Tener el lenguaje Q# instalado, el cual es parte del Quantum Development Kit (QDK) de Microsoft.

En el caso de los cuadernos de Qiskit y Q#, se tiene estructurado un cuaderno interactivo de formato `.ipynb`, mientras que para Yao tenemos lo mismo pero adicionalmente un `.jl` ejecutable desde [Pluto.jl](https://github.com/fonsp/Pluto.jl) para mejor rendimiento e interactividad.
