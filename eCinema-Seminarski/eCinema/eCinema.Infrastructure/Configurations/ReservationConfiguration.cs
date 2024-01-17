using eCinema.Core;
using Microsoft.EntityFrameworkCore;
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

            builder.Property(e => e.isConfirm)
               .IsRequired().HasDefaultValue(false);

            builder.HasOne(e => e.Show)
                .WithMany(e => e.Reservations)
                .HasForeignKey(e => e.ShowId)
                .IsRequired();

            builder.HasOne(e => e.Seat)
               .WithMany(e => e.Reservations)
               .HasForeignKey(e => e.SeatId)
               .IsRequired();

            builder.HasOne(e => e.User)
                .WithMany(e => e.Reservations)
                .HasForeignKey(e => e.UserId)
                .IsRequired();
        }
    }
}
