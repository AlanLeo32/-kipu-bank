<img width="942" height="479" alt="image" src="https://github.com/user-attachments/assets/a180a3c9-ba8b-41e4-858e-2226fe561bc3" /># -kipu-bank
¿Que es kipuBank?
Es un contrato inteligente que funciona como un banco en el cual contaras con una boveda personal para gestionar tus eth de una manera segura 
¿Que nos permite KipuBank?
_Depositar ETH en una bóveda personal, siempre que el límite global (bankCap) no se supere.
_Retirar fondos hasta un máximo fijo por transacción (umbral), definido como inmutable en el despliegue.
_Consultar el saldo y ver registros de depósitos/retiros.
_Emitir eventos para el deposito y retiro

Dirección del contrato desplegado
0xd9431156d2fb8fb892e67aa62d750b4be63f1c1c

Instrucciones de despliegue
_Abrí Remix IDE
_En el panel de archivos, creá una nueva carpeta llamada contracts/ y dentro de ella pegá el código de KipuBank.sol.
_En la pestaña Solidity Compiler:
_Seleccioná la versión 0.8.26 .
_Hacé clic en Compile KipuBank.sol.
_En la pestaña Deploy & Run Transactions:
_Conecta tu billetera, recomiendo metamask.
_Seleccioná el environment que quieras usar:
_Injected Provider - MetaMask → conecta tu MetaMask para desplegar en Sepolia, Goerli o Mainnet.
_En el campo de despliegue, ingresá los parámetros requeridos por el constructor de KipuBank.sol:
_uint256 _bankCap → el límite global de depósitos (ej. 100 ether).
_uint256 _umbral → el límite fijo de retiros por transacción (ej. 1 ether).
_Hacé clic en Deploy.
_Confirmá la transacción en MetaMask.
_Una vez desplegado, vas a ver el contrato en la sección Deployed Contracts, con sus funciones disponibles para interactuar

¿Cómo interactuar con el contrato.?
depositar -> permite depositar ETH (usá el campo "Value" arriba para especificar cuánto wei(unidad minima de eth) quieres enviar).

retirar(uint256 monto) ->Retira fondos de tu bóveda, hasta el máximo permitido por transacción (i_umbral).

consultaSaldo(address usuario)->Devuelve el saldo en la bóveda del usuario indicado.

getTotalDepositos() ->Devuelve el total global de ETH depositado en el contrato.

monto_total_depositado()->Devuelve la suma de todos los depósitos realizados en el banco.

numero_depositos()->Devuelve la cantidad total de depósitos efectuados.

numero_retiros()->Devuelve la cantidad total de retiros efectuados.

bankCap()->Límite global de depósitos permitido en el contrato.

i_umbral()->Umbral fijo de retiro máximo por transacción.
