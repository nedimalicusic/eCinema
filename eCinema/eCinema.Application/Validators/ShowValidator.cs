using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ShowValidator : AbstractValidator<ShowUpsertDto>
    {
        public ShowValidator()
        {
            RuleFor(c => c.Format).NotNull().NotEmpty();
            RuleFor(c => c.Date).NotNull();
            RuleFor(c => c.StartTime).NotNull();
            RuleFor(c => c.CinemaId).NotNull();
            RuleFor(c => c.MovieId).NotNull();
        }
    }
}
