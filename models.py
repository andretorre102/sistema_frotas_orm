from typing import Optional, List
from datetime import date, datetime
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, String, Integer, Float, Date, DateTime, Text

class Base(DeclarativeBase):
    pass

class Motorista(Base):
    __tablename__ = 'motorista'
    
    cpf: Mapped[str] = mapped_column(String(14), primary_key=True)
    nome_motorista: Mapped[str] = mapped_column(String(100), nullable=False)
    categoria_cnh: Mapped[str] = mapped_column(String(5), nullable=False)
    tempo_experiencia: Mapped[int] = mapped_column(Integer, default=0)
    disponibilidade: Mapped[bool] = mapped_column(default=True)
    
    viagens: Mapped[list["Viagem"]] = relationship("Viagem", back_populates="motorista")

class Veiculo(Base):
    __tablename__ = 'veiculo'
    
    placa: Mapped[str] = mapped_column(String(10), primary_key=True)
    tipo: Mapped[str] = mapped_column(String(20), nullable=False)
    marca: Mapped[str] = mapped_column(String(50), nullable=False)
    modelo: Mapped[str] = mapped_column(String(50), nullable=False)
    ano: Mapped[int] = mapped_column(Integer, nullable=False)
    status: Mapped[str] = mapped_column(String(20), default='ATIVO')
    quilometragem: Mapped[float] = mapped_column(Float, default=0.0)
    consumo_medio: Mapped[float] = mapped_column(Float, nullable=True)
    
    viagens: Mapped[list["Viagem"]] = relationship("Viagem", back_populates="veiculo")
    manutencoes: Mapped[list["Manutencao"]] = relationship("Manutencao", back_populates="veiculo")
    abastecimentos: Mapped[list["Abastecimento"]] = relationship("Abastecimento", back_populates="veiculo")

class Viagem(Base):
    __tablename__ = 'viagem'
    
    id_viagem: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    origem: Mapped[str] = mapped_column(String(100), nullable=False)
    destino: Mapped[str] = mapped_column(String(100), nullable=False)
    data_saida: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    data_chegada: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    distancia: Mapped[float] = mapped_column(Float, nullable=True)
    
    cpf: Mapped[str] = mapped_column(String(14), ForeignKey('motorista.cpf'), nullable=False)
    placa: Mapped[str] = mapped_column(String(10), ForeignKey('veiculo.placa'), nullable=False)
    
    motorista: Mapped["Motorista"] = relationship("Motorista", back_populates="viagens")
    veiculo: Mapped["Veiculo"] = relationship("Veiculo", back_populates="viagens")

class Manutencao(Base):
    __tablename__ = 'manutencao'
    
    id_manutencao: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    data_manutencao: Mapped[date] = mapped_column(Date, nullable=False)
    tipo_manutencao: Mapped[str] = mapped_column(String(20), nullable=False)
    descricao_manutencao: Mapped[Optional[str]] = mapped_column(Text)
    custo: Mapped[float] = mapped_column(Float, nullable=False)
        
    placa: Mapped[str] = mapped_column(String(10), ForeignKey('veiculo.placa'), nullable=False)
    
    veiculo: Mapped["Veiculo"] = relationship("Veiculo", back_populates="manutencoes")

class Abastecimento(Base):
    __tablename__ = 'abastecimento'
    
    id_abastecimento: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    data_abastecimento: Mapped[date] = mapped_column(Date, nullable=False)
    tipo_combustivel: Mapped[str] = mapped_column(String(20), nullable=False)
    litros: Mapped[float] = mapped_column(Float, nullable=False)
    valor: Mapped[float] = mapped_column(Float, nullable=False)
    
    placa: Mapped[str] = mapped_column(String(10), ForeignKey('veiculo.placa'), nullable=False)
    
    veiculo: Mapped["Veiculo"] = relationship("Veiculo", back_populates="abastecimentos")