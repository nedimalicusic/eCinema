using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class ShowConfiguration : BaseConfiguration<Show>
    {
        public override void Configure(EntityTypeBuilder<Show> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Date)
            .IsRequired();

            builder.Property(e => e.StartTime)
            .IsRequired();

            builder.Property(e => e.Format)
           .IsRequired();

            builder.HasOne(e => e.Cinema)
               .WithMany(e => e.Shows)
               .HasForeignKey(e => e.CinemaId)
               .IsRequired();

            builder.HasOne(e => e.Movie)
               .WithMany(e => e.Shows)
               .HasForeignKey(e => e.MovieId)
               .IsRequired();
        }
    }
}
