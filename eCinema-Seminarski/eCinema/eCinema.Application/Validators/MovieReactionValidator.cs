using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class MovieReactionValidator : AbstractValidator<MovieReactionUpsertDto>
    {
        public MovieReactionValidator()
        {
            RuleFor(c => c.MovieId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.UserId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.Rating).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
