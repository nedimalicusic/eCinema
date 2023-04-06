using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class ShowSeatConfiguration : BaseConfiguration<ShowSeat>
    {
        public override void Configure(EntityTypeBuilder<ShowSeat> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.isReserved)
            .IsRequired();

            builder.Property(e => e.isSelected)
            .IsRequired();

            builder.Property(e => e.isAvailable)
            .IsRequired();

            builder.HasOne(e => e.Show)
             .WithMany(e => e.ShowSeats)
             .HasForeignKey(e => e.ShowId)
             .IsRequired();

            builder.HasOne(e => e.Seat)
             .WithMany(e => e.ShowSeats)
             .HasForeignKey(e => e.SeatId)
             .IsRequired();
        }
    }
}
