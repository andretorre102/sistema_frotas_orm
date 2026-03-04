from sqlalchemy import select, desc
from models import Motorista, Veiculo, Viagem, Manutencao, Abastecimento
from database import SessionLocal

# ====================================================
# PARTE 3 - CRUD
# ====================================================

# Definição das funções para cada operação CRUD
 
# Função para inserir um novo motorista no banco de dados
def inserir_motorista(session, cpf, nome_motorista, categoria_cnh, tempo_experiencia):
    motorista = Motorista(
        cpf=cpf,
        nome_motorista=nome_motorista,
        categoria_cnh=categoria_cnh,
        tempo_experiencia=tempo_experiencia
    )
    session.add(motorista)
    session.commit()
    print(f"Motorista {nome_motorista} inserido com sucesso.")

# Função para listar todos os motoristas ordenados por nome
def listar_motoristas_ordenados(session):
    motoristas = session.execute(select(Motorista).order_by(Motorista.nome_motorista)).scalars().all()
    for motorista in motoristas:
        print(f"CPF: {motorista.cpf}, Nome: {motorista.nome_motorista}, Categoria CNH: {motorista.categoria_cnh}, Experiência: {motorista.tempo_experiencia} anos")

# Função para atualizar o status de um veículo
def atualizar_status_veiculo(session, placa, novo_status):
    veiculo = session.get(Veiculo, placa)
    if veiculo:
        veiculo.status = novo_status
        session.commit()
        print(f"Status do veículo {placa} atualizado para {novo_status}.")
    else:
        print(f"Veículo com placa {placa} não encontrado.")

# Função para deletar um motorista do banco de dados
def deletar_motorista(session, cpf):
    motorista = session.get(Motorista, cpf)
    if motorista:
        session.delete(motorista)
        session.commit()
        print(f"Motorista com CPF {cpf} deletado com sucesso.")
    else:
        print(f"Motorista com CPF {cpf} não encontrado.")

# ====================================================
# PARTE 4 - CONSULTAS
# ====================================================

# Definição das funções para cada consulta solicitada

# 4.1. Consulta de Manutenções por Veículo
def consultar_manutencoes_por_veiculo(session):
    comando = select(Veiculo.modelo, Veiculo.placa, Manutencao.data_manutencao, Manutencao.custo).join(Veiculo.manutencoes)
    resultados = session.execute(comando).all()
    
    print("Histórico de Manutenções por Veículo")
    for modelo, placa, data, custo in resultados:
        print(f"Veículo: {modelo} ({placa}) | Data: {data} | Gasto: R$ {custo:.2f}")

# 4.2. Consulta de Abastecimentos por Marca
def consultar_abastecimentos_por_marca(session, marca_desejada):
    comando = select(Abastecimento).join(Abastecimento.veiculo).where(Veiculo.marca == marca_desejada)
    abastecimentos = session.execute(comando).scalars().all()
    
    print(f"Abastecimentos da frota da marca {marca_desejada}")
    if not abastecimentos:
        print("Nenhum abastecimento encontrado para esta marca.")
    for abs in abastecimentos:
        print(f"Data: {abs.data_abastecimento} | {abs.tipo_combustivel}: {abs.litros}L | Total: R$ {abs.valor:.2f}")

# 4.3. Consulta de Viagens Longas Concluídas
def consultar_viagens_longas_concluidas(session):
    comando = select(Viagem).where(Viagem.data_chegada.is_not(None)).order_by(desc(Viagem.distancia))
    viagens = session.execute(comando).scalars().all()
    
    print("Ordenação de viagens mais longas concluídas")
    for v in viagens:
        print(f"Origem: {v.origem} -> Destino: {v.destino} | Distância: {v.distancia} km")
        
# Execução das operações CRUD e consultas

if __name__ == "__main__":
    
    # Criando uma única sessão
    with SessionLocal() as session:
        
        # Execução das Operações CRUD

        print("\n CREATE (Inserindo Motoristas)")
        inserir_motorista(session, '110.001.111-10', 'Klênio Silva', 'B', 5)
        inserir_motorista(session, '121.212.121-12', 'Larissa Oliveira', 'C', 10)
        inserir_motorista(session, '131.313.131-13', 'Marcos Souza', 'D', 15)

        print("\n READ (Listagem Ordenada)")
        listar_motoristas_ordenados(session)
        
        print("\n UPDATE (Atualizando Veículo)")
        atualizar_status_veiculo(session, 'ABC-1234', 'MANUTENCAO')
        atualizar_status_veiculo(session, 'FUS-9999', 'ATIVO')   

        print("\n DELETE (Deletando Motorista)")
        deletar_motorista(session, '131.313.131-13')

        # Execução das Consultas.

        print("\n Consulta 4.1 - Manutenções por Veículo")
        consultar_manutencoes_por_veiculo(session)
        
        print("\n Consulta 4.2 - Abastecimentos por Marca (Exemplo: 'Toyota')")
        consultar_abastecimentos_por_marca(session, 'Toyota')
        
        print("\n Consulta 4.3 - Viagens Longas Concluídas")
        consultar_viagens_longas_concluidas(session)

