using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class ReservationConfiguration : BaseConfiguration<Reservation>
    {
        public override void Configure(EntityTypeBuilder<Reservation> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.isActive)
               .IsRequired();

            builder.Property(e => e.IsClosed)
               .IsRequired();

            builder.HasOne(e => e.ShowSeat)
                .WithMany(e => e.Reservations)
                .HasForeignKey(e => e.ShowSeatId)
                .IsRequired();

            builder.HasOne(e => e.User)
                .WithMany(e => e.Reservations)
                .HasForeignKey(e => e.UserId)
                .IsRequired();
        }
    }
}
