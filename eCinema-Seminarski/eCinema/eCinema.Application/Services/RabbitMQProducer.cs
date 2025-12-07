using eCinema.Application.Interfaces.Services;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System.Text;

namespace eCinema.Application.Services;
public class RabbitMQProducer : IRabbitMQProducer
{
    public void SendMessage<T>(T message)
    {
        var factory = new ConnectionFactory
        {
            HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost",
            Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
            UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
            Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
        };
        factory.ClientProvidedName = "Rabbit";

        IConnection connection = factory.CreateConnection();
        IModel channel = connection.CreateModel();

        string exchangeName = "test_exchange";
        string routingKey = "route_queue";
        string queueName = "MessageQueue";

        channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);
        channel.QueueDeclare(queueName, true, false, false, null);
        channel.QueueBind(queueName, exchangeName, routingKey, null);

        string messageJson = JsonConvert.SerializeObject(message);
        byte[] messageBodyBytes = Encoding.UTF8.GetBytes(messageJson);
        channel.BasicPublish(exchangeName, routingKey, null, messageBodyBytes);
    }
}
