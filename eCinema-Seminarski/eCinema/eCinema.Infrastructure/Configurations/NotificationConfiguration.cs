using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class NotificationConfiguration : BaseConfiguration<Notification>
    {
        public override void Configure(EntityTypeBuilder<Notification> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Title)
                 .IsRequired();

            builder.Property(e => e.Description)
              .IsRequired();

            builder.Property(e => e.SendOnDate)
              .IsRequired(false);

            builder.Property(e => e.DateRead)
              .IsRequired(false);

            builder.Property(e => e.Seen)
             .IsRequired(false);

            builder.HasOne(e => e.User)
                   .WithMany(e => e.Notifications)
                   .HasForeignKey(e => e.UserId)
                   .IsRequired();
        }
    }
}
