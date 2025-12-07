namespace eCinema.Application.Interfaces.Services;
public interface IRabbitMQProducer
{
    public void SendMessage<T>(T message);
}

