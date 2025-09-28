//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


//@title KipuBank
//@author Alan-Juares
//@notice Este contrato permite a los usuarios depositar y extraer eth
//@dev se trabaja con wei ya que es la unidad minima de eth,trabajar con eth directamente podria generar un truncamiento en algun monto cambiando el valor deseado
contract KipuBank{
    /*/////////////////Variables de estado/////////////////*/

    //@notice mapping para almacenar los depositos de usuarios
    mapping (address cliente=> uint256 cantidad) private depositos; //mapeo de direcciones de clientes a sus depósitos
    //@notice variable inmutable que define la maxima cantidad que pueden retirar por transaccion(wei)
    uint256 public immutable i_umbral; 
    //@notice variable que define el limite global de depositos es decir cuanto eth como maximo recibe el contrato (wei)
    uint256 public immutable bankCap; 
    //@notice variable que almacena el numero de depositos total realizado en el contrato
    uint256 public numero_depositos;
    //@notice variable que almacena el numero de extracion total realizado en el contrato
    uint256 public numero_retiros;
    //@notice variable que almacena el monto total de depositos existentes en el contrato
    uint256 public monto_total_depositos;

    /*/////////////////Eventos/////////////////*/

    //@notice evento emitido cuando se realiza un deposito
    event DepositoRealizado(address cliente,uint256 cantidad);
    //@notice evento emitido cuando se retira eth
    event RetiroRealizado(address cliente,uint256 cantidad);

    /*/////////////////Errores/////////////////*/

    //@notice error emitido cuando la cantidad ingresada es 0
    error CantidadCero();
    //@notice error emitido cuando se supera el limite global de depositos
    error LimiteSuperado(uint256 monto,uint256 limite);
    //@notice error emitido cuando no se dispone de saldo suficiente para retirar la cantidad ingresada
    error SaldoInsuficiente(uint256 monto,uint256 saldo);
    //@notice error emitido cuando se supera la cantidad permitida de retiro por transaccion
    error UmbralSuperado(uint256 monto,uint256 umbral);
    //@notice error emitido cuando falla el retiro
    error RetiroFallido(bytes error);

    /*/////////////////Constructor/////////////////*/

    //@param _umbral valor fijo maximo que se puede extraer por transaccion (wei)
    //@param _bankCap limite global de depositos (wei)
    constructor(uint256 _umbral,uint256 _bankCap){
        if(_umbral==0 || _bankCap==0 ) revert CantidadCero();
        i_umbral=_umbral;
        bankCap=_bankCap;
    }
    /*/////////////////Funciones/////////////////*/

    //@notice controla que el valor ingresado no sea 0
    //@param valor monto a controlar
    modifier controlCero(uint256 valor){
        if(valor==0)revert CantidadCero();
        _;
    }
    //@notice deposita eth en tu cuenta
    function depositar() external payable controlCero(msg.value) {
        uint256 monto=msg.value;
        address cliente=msg.sender;
        _validarDeposito(monto);
        monto_total_depositos+=monto;      
        depositos[cliente]+=monto;
        numero_depositos++;
        emit DepositoRealizado(cliente,monto);
    }
    //@notice retira eth de tu cuenta
    //@param monto la cantidad que el usuario solicita retirar,si se retira con exito se transfiere a la cuenta del usuario
    function retirar(uint256 monto) external  controlCero(monto){
        address cliente=msg.sender;
        _validarRetiro(monto,cliente);
        depositos[cliente]-=monto;
        monto_total_depositos-=monto;   
        numero_retiros++;
        (bool exito,bytes memory error) = cliente.call{value: monto}("");
        if(!exito) revert RetiroFallido(error);
        emit RetiroRealizado(cliente,monto);
    }
    // @notice devuelve el total de depósitos hechos en el banco
    // @return cantidad total depositada 
    function getTotalDepositos() external view returns (uint256) {
        return monto_total_depositos;
    }
    /// @notice Consulta el saldo de tu bóveda
    /// @return balance Monto de ETH en la bóveda
    function consultaSaldo() external view returns (uint256 balance) {
        return depositos[msg.sender];
    }
    //@notice controla que el retiro sea valido
    //@param monto cantidad que el usuario solicita retirar
    //@param cliente direccion de la cuenta de la boveda personal
    function _validarRetiro(uint256 monto,address cliente)private  view {
        if(monto>i_umbral) revert UmbralSuperado(monto,i_umbral);
        if(monto>depositos[cliente]) revert SaldoInsuficiente(monto,depositos[cliente]); 
    }
    //@notice controla que el deposito no supere el limite global
    //@param monto cantidad que el usuario solicita depositar
    function _validarDeposito(uint256 monto) private view  {
        if(monto_total_depositos+monto>bankCap) revert LimiteSuperado(monto,bankCap);
    }
    
}