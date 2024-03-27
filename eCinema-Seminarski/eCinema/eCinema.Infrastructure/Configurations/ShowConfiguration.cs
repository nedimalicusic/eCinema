using eCinema.Core;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class ShowConfiguration : BaseConfiguration<Show>
    {
        public override void Configure(EntityTypeBuilder<Show> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.StartsAt)
            .IsRequired();

            builder.Property(e => e.EndsAt)
            .IsRequired();


            builder.Property(e => e.Price)
            .IsRequired();

            builder.HasOne(e => e.ShowType)
                 .WithMany(e => e.Shows)
                 .HasForeignKey(e => e.ShowTypeId)
                 .OnDelete(DeleteBehavior.NoAction)
                 .IsRequired();

            builder.HasOne(e => e.ReccuringShow)
              .WithMany(e => e.Shows)
              .HasForeignKey(e => e.RecurringShowId)
              .OnDelete(DeleteBehavior.NoAction)
              .IsRequired(false);


            builder.HasOne(e => e.Cinema)
               .WithMany(e => e.Shows)
               .HasForeignKey(e => e.CinemaId)
               .OnDelete(DeleteBehavior.NoAction)
               .IsRequired();

            builder.HasOne(e => e.Movie)
               .WithMany(e => e.Shows)
               .HasForeignKey(e => e.MovieId)
               .OnDelete(DeleteBehavior.NoAction)
               .IsRequired();
        }
    }
}
