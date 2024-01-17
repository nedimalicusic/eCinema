using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class SeatConfiguration : BaseConfiguration<Seat>
    {
        public override void Configure(EntityTypeBuilder<Seat> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Row)
               .IsRequired();

            builder.Property(e => e.Column)
               .IsRequired();
        }
    }
}
